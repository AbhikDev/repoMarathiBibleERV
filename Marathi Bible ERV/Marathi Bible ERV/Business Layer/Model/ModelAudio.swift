//
//  ModelAudio.swift
//  English Bible
//
//  Created by Abhik Das on 09/02/24.
//

import Foundation
struct ModelAudio: Codable {
    let shortName, longName, code, type: String?
    let chapters: [ChapterAudio]?

    enum CodingKeys: String, CodingKey {
        case shortName = "short_name"
        case longName = "long_name"
        case code = "code"
        case type = "type"
        case chapters = "chapters"
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shortName = try values.decodeIfPresent(String.self, forKey: .shortName)
        longName = try values.decodeIfPresent(String.self, forKey: .longName)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        chapters = try values.decodeIfPresent([ChapterAudio].self, forKey: .chapters)
    }
}

// MARK: - Chapter
struct ChapterAudio: Codable {
    let number: Int?
    let audio: String?
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case audio = "audio"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        audio = try values.decodeIfPresent(String.self, forKey: .audio)
    }
}
