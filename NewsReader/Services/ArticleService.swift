//
//  ArticleService.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import Combine
import Foundation
import SwiftUI

protocol ArticleService {
    func get(articles: LoadableSubject<[DisplayItem]>)
}

struct DefaultArticleService: ArticleService {
    let webRepository: ArticlesRepository
    
    init(webRepository: ArticlesRepository) {
        self.webRepository = webRepository
    }

    func get(articles: LoadableSubject<[DisplayItem]>) {
        let cancelBag = CancelBag()
        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        webRepository.loadArticles()
            .ensureTimeSpan(0.5)
            .map{$0.map{DisplayItem(popularArticle: $0)}}
            .sinkToLoadable { articles.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}
