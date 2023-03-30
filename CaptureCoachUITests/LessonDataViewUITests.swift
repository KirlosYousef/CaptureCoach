//
//  LessonDataViewUITests.swift
//  CaptureCoachUITests
//
//  Created by Kirlos Yousef on 29/03/2023.
//

import XCTest

final class LessonDataViewUITests: XCTestCase {
    var app = XCUIApplication()
    var lessons: XCUIElementQuery!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        lessons = app.collectionViews["LessonsList"].cells
    }
    
    func testLessonContent() {
        let firstLessonCell = lessons.firstMatch
        firstLessonCell.tap()
        
        // test video thumbnail
        XCTAssertTrue(app.otherElements["VideoThumbnailView"].exists)
        
        // test lesson data view
        XCTAssertTrue(app.staticTexts["Lesson title"].exists)
        XCTAssertTrue(app.staticTexts["Lesson description"].exists)
        
        // test download button
        XCTAssertTrue(app.buttons["Download lesson"].exists)
    }
    
    func testFirstLesson() {
        // First tap the last visible cell
        let lastLessonCell = lessons.element(boundBy: lessons.count - 1)
        lastLessonCell.tap()
        
        // Navigate to first
        while app.buttons["Previous lesson"].exists{
            app.buttons["Previous lesson"].tap()
        }
        
        // test previous lesson button, which is hidden in first lesson
        XCTAssertFalse(app.buttons["Previous lesson"].exists)
        
        // test next lesson button
        XCTAssertTrue(app.buttons["Next lesson"].exists)
    }
    
    func testLastLesson() {
        // Tap the first cell
        let firstLessonCell = lessons.firstMatch
        firstLessonCell.tap()
        
        // Navigate to last
        while app.buttons["Next lesson"].exists{
            app.buttons["Next lesson"].tap()
        }
        
        // test previous lesson button, which is hidden in first lesson
        XCTAssertTrue(app.buttons["Previous lesson"].exists)
        
        // test next lesson button
        XCTAssertFalse(app.buttons["Next lesson"].exists)
    }
    
    func testPlayVideo() {
        let firstLessonCell = lessons.firstMatch
        firstLessonCell.tap()
        
        let videoThumbnail = app.otherElements["VideoThumbnailView"]
        videoThumbnail.tap()
        
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                    object: videoThumbnail)
        XCTWaiter().wait(for: [expectation], timeout: 5)
    }
    
    func testCancelDownloadButton() {
        let firstLessonCell = lessons.firstMatch
        firstLessonCell.tap()
        
        let downloadBtn = app.buttons["Download lesson"]
        downloadBtn.tap()
        
        let cancelBtn = app.staticTexts["Cancel download"]
        cancelBtn.tap()
        
        XCTAssertTrue(downloadBtn.exists)
    }
}
