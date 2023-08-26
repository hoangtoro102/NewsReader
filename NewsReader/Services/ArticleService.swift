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
    let dbRepository: ArticlesDBRepository
    
    init(webRepository: ArticlesRepository, dbRepository: ArticlesDBRepository) {
        self.webRepository = webRepository
        self.dbRepository = dbRepository
    }

    func get(articles: LoadableSubject<[DisplayItem]>) {
        let cancelBag = CancelBag()
        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
    
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedArticles()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshArticleList()
                }
            }
            .flatMap { [dbRepository] in
                dbRepository.fetch()
            }
            .map{$0.map{DisplayItem(popularArticle: $0)}}
            .sinkToLoadable { articles.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    private func refreshArticleList() -> AnyPublisher<Void, Error> {
        return webRepository.loadArticles()
            .ensureTimeSpan(0.5)
            .flatMap { cleanAndStore($0) }
            .eraseToAnyPublisher()
    }
    
    private func cleanAndStore(_ articles: [Article]) -> AnyPublisher<Void, Error> {
        return dbRepository.deleteAll()
            .flatMap { [dbRepository] in
                dbRepository.store(articles: articles)
            }
            .eraseToAnyPublisher()
    }
}
