//
//  LessonsFetcher.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 26/03/2023.
//

import Foundation
import Combine

/**
 This class to fetches lessons data from an API endpoint.
 */
class LessonsFetcher {
    
    // MARK: - Properties
    private let url = "https://iphonephotographyschool.com/test-api/lessons"
    
    // MARK: - Public Methods
    
    /**
     Fetches lessons data from the API endpoint.
     
     - Returns: An `AnyPublisher` that emits `Data` objects or throws an `Error`.
     */
    func fetch() -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .tryMap { element -> Data in
                // Make sure there is no error returned
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .eraseToAnyPublisher()
    }
}
