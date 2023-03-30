//
//  LessonVCWrapperTests.swift
//  CaptureCoachTests
//
//  Created by Kirlos Yousef on 28/03/2023.
//

import XCTest
import Combine
@testable import CaptureCoach

class LessonVCWrapperTests: XCTestCase {
    
    var lessonsVM: LessonsViewModel!
    var lessonVCWrapper: LessonVCWrapper!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // Initializeres
        lessonsVM = LessonsViewModel()
        lessonVCWrapper = LessonVCWrapper(lessonsVM: lessonsVM,
                                          selectedInd: 0,
                                          activeDownloads: [:])
        
        fetchLessons()
    }
    
    override func tearDown() {
        lessonsVM = nil
        lessonVCWrapper = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testGetFirstLesson() throws {
        let lessonVCWrapper = LessonVCWrapper(lessonsVM: lessonsVM, selectedInd: 0)
        let lessonData = lessonVCWrapper.getLesson()
        
        // Verify that the lesson data is correct and is first
        XCTAssertEqual(lessonData.isFirst, true)
    }
    
    func testGetDownloadStatusOnProgress() throws {
        let url = "https://example.com/video1.mp4"
        lessonVCWrapper = LessonVCWrapper(lessonsVM: lessonsVM,
                                          selectedInd: 0,
                                          activeDownloads: [url: 50])
        
        // Verify that the download status is correct
        let downloadStatus = lessonVCWrapper.getDownloadStatus(forURL: url)
        XCTAssertEqual(downloadStatus, .onProgress(50))
    }
    
    func testGetDownloadStatusDownloaded() throws {
        // Download a video to the local storage
        let urlString = "https://example.com/video1.mp4"
        
        let expectation = XCTestExpectation(description: "Video downloaded")
        VideoService.shared.downloadVideo(from: urlString, progressHandler: { _ in }) {
            expectation.fulfill() // Downloaded
        }
        wait(for: [expectation], timeout: 5.0)
        
        let downloadStatus = lessonVCWrapper.getDownloadStatus(forURL: urlString)
        
        // Verify that the download status is correct
        XCTAssertEqual(downloadStatus, .downloaded)
        
        // Clean up the downloaded video
        let localURL = try XCTUnwrap(VideoService.shared.localVideoUrl(for: urlString))
        try FileManager.default.removeItem(at: localURL)
    }
    
    func testGetDownloadStatusNone() {
        let url = "https://example.com/video1.mp4"
        let status = lessonVCWrapper.getDownloadStatus(forURL: url)
        XCTAssertEqual(status, .none)
    }
    
    private func fetchLessons(){
        let expectation = XCTestExpectation(description: "Lessons fetched")
        
        lessonsVM.$lessons
            .dropFirst() // Drops the initial value of an empty `Lessons` object
            .sink { lessons in
                XCTAssertGreaterThan(lessons.data.count, 0)
                expectation.fulfill() // Passed
            }
            .store(in: &cancellables)
        
        // Fetch lessons before each test
        lessonsVM.fetchLessons()
        
        wait(for: [expectation], timeout: 5.0)
    }
}
