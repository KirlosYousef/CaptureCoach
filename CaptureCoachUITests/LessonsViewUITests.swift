//
//  LessonsViewUITests.swift
//  LessonsViewUITests
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import XCTest

final class LessonsViewUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func testLessonsList() {
        let lessonsList = app.collectionViews["LessonsList"]
        XCTAssertTrue(lessonsList.exists)
        
        let lessons = lessonsList.cells
        XCTAssertTrue(lessons.count > 0, "Lessons list should have at least one cell")
        
        let firstLessonCell = lessons.firstMatch
        XCTAssertTrue(firstLessonCell.staticTexts["LessonName"].exists)
        XCTAssertTrue(firstLessonCell.images["LessonImage"].exists)
    }
}
