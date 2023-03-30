//
//  ImageServiceTests.swift
//  CaptureCoachTests
//
//  Created by Kirlos Yousef on 28/03/2023.
//

import XCTest
import Combine
@testable import CaptureCoach

class ImageServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testDownloadImageToCache() throws {
        let url = "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg"
        let expectation = XCTestExpectation(description: "Image downloaded")

        ImageService.downloadImage(from: url) { image in
            XCTAssertFalse(image == nil)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        // Verify that the image is already stored
        let localURL = try XCTUnwrap(ImageService.getImageFileUrl(from: url))
        _ = try XCTUnwrap(ImageService.loadImage(from: localURL))
        
        // Clean up the downloaded image
        try FileManager.default.removeItem(at: localURL)
    }
}
