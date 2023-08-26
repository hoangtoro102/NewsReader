//
//  Article.swift
//  NewsReader
//
//  Created by MacBook on 25/08/2023.
//

import Foundation

struct Article: Codable, Equatable {
    let id: Int64?
    let title: String?
    let publishedDate: String?
    let media: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate = "published_date"
        case media
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}

struct Media: Codable {
    let type: String?
    let mediaMetadata: [Metadata]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case mediaMetadata = "media-metadata"
    }
}

struct Metadata: Codable {
    let url: String?
}
