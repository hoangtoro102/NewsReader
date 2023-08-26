//
//  DisplayItem.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

struct DisplayItem: Identifiable {
    let id: String
    let title: String
    let date: String
    let photoUrl: String
    
    init(popularArticle: Article) {
        self.title = popularArticle.title ?? "<Missing title>"
        self.date = popularArticle.publishedDate ?? "<Missing published date>"
        self.id = "\(popularArticle.id ?? 0)"        
        self.photoUrl = popularArticle.media?.first?.mediaMetadata?.first?.url ?? NetworkConstants.defaultImageUrl
    }
}
