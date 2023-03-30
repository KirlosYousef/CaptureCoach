//
//  LessonsViewModel.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import Foundation
import Combine

/// View model for handling lessons data.
class LessonsViewModel: ObservableObject {
    
    // MARK: - Properties
    /// Published property for storing fetched lessons data.
    @Published var lessons = Lessons(data: [])
    
    /// Instance of `LessonsFetcher` used for fetching lessons from the API endpoint.
    private let lessonsFetcher = LessonsFetcher()
    
    /// Set to store subscriptions to Combine publishers.
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    /// Fetch lessons from either the API endpoint or local storage.
    func fetchLessons() {
        if Reachability.isConnectedToNetwork() {
            fetchLessonsFromAPI()
        } else {
            loadLessonsFromLocalStorage()
        }
    }
    
    // MARK: - Private Methods
    /// Fetch lessons from the API endpoint.
    private func fetchLessonsFromAPI() {
        lessonsFetcher.fetch()
            .decode(type: Lessons.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .failure(let error):
                        print("Lessons fetcher error: \(error)")
                    case .finished:
                        print("Lessons fetched successfully")
                    }
                },
                receiveValue: { lessons in
                    self.lessons = lessons
                    self.saveLessonsToLocalStorage(lessons: lessons)
                }
            )
            .store(in: &subscriptions)
    }
    
    /// Load lessons from local storage.
    private func loadLessonsFromLocalStorage() {
        if let data = UserDefaults.standard.data(forKey: "lessonsData") {
            do {
                lessons = try JSONDecoder().decode(Lessons.self, from: data)
            } catch {
                print("Error loading lessons data from local storage: \(error)")
            }
        } else {
            print("No internet connection and no stored data")
        }
    }
    
    /// Save lessons data to local storage.
    private func saveLessonsToLocalStorage(lessons: Lessons) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(lessons)
            UserDefaults.standard.set(data, forKey: "lessonsData")
        } catch {
            print("Error saving lessons data to local storage: \(error)")
        }
    }
}
