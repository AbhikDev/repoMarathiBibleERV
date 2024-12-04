//
//  ModelStory.swift
//  English Bible
//
//  Created by Abhik Das on 09/02/24.
//

import Foundation
// MARK: - Welcome
struct ModelStory: Codable {
   
    let shortName, longName, code, type: String?
    let chapters: [Chapter]?
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
        chapters = try values.decodeIfPresent([Chapter].self, forKey: .chapters)
    }

}

// MARK: - Chapter
struct Chapter: Codable {
    let number: Int?
    let audio: String?
    let subtitles: [Subtitle]?

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case audio = "audio"
        case subtitles = "subtitles"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        audio = try values.decodeIfPresent(String.self, forKey: .audio)
        subtitles = try values.decodeIfPresent([Subtitle].self, forKey: .subtitles)
    }

}

// MARK: - Subtitle
struct Subtitle: Codable {
    let title: String?
    let reference: String?
    let sequence: Int?
    let verses: [Verse]?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case reference = "reference"
        case sequence = "sequence"
        case verses = "verses"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decodeIfPresent(String.self, forKey: .title)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        sequence = try values.decodeIfPresent(Int.self, forKey: .sequence)
        verses = try values.decodeIfPresent([Verse].self, forKey: .verses)
    }

}
// MARK: - Verse
struct Verse: Codable {
    let number, content: String?
    let sequence: Int?

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case content = "content"
        case sequence = "sequence"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decodeIfPresent(String.self, forKey: .number)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        sequence = try values.decodeIfPresent(Int.self, forKey: .sequence)
    }

}
