//
//  Lesson.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import Foundation

struct Lessons: Decodable, Encodable{
    let data: [Lesson]
    
    enum CodingKeys: String, CodingKey {
        case data = "lessons"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
}

struct Lesson: Decodable, Encodable, Hashable{
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let videoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
        case videoUrl = "video_url"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(videoUrl, forKey: .videoUrl)
    }
}
