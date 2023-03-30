//
//  LessonsViewModelTests.swift
//  LessonsViewModelTests
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import XCTest
import Combine
@testable import CaptureCoach

final class LessonsViewModelTests: XCTestCase {
    
    var viewModel: LessonsViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = LessonsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchLessons() {
        let expectation = XCTestExpectation(description: "Lessons fetched")
        
        viewModel.$lessons
            .dropFirst() // Drops the initial value of an empty `Lessons` object
            .sink { lessons in
                XCTAssertGreaterThan(lessons.data.count, 0)
                expectation.fulfill() // Passed
            }
            .store(in: &cancellables)
        
        viewModel.fetchLessons()
        
        // Wait for the expectation to be fulfilled, otherwise the test will be failed
        wait(for: [expectation], timeout: 5.0)
    }
}
