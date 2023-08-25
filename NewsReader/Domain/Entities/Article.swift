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
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate = "published_date"
    }
}
