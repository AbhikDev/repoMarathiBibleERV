//
//  ModelStory.swift
//  English Bible
//
//  Created by Abhik Das on 08/02/24.
//

import Foundation
// MARK: - Datum
struct ModelStoryList: Codable {
    let shortName, longName, code: String
    let type: String
    let sequence, chapterCount: Int

    enum CodingKeys: String, CodingKey {
        case shortName = "short_name"
        case longName = "long_name"
        case code, type, sequence
        case chapterCount = "chapter_count"
    }
}
