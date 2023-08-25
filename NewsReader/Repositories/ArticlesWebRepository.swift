//
//  ArticlesRepository.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import Combine
import Foundation

protocol ArticlesRepository: WebRepository {
    func loadArticles() -> AnyPublisher<[Article], Error>
}

struct DefaultArticlesRepository: ArticlesRepository {
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadArticles() -> AnyPublisher<[Article], Error> {
        let request: AnyPublisher<PopularResult, Error> = call(endpoint: API.mostViewed)
        return request
            .compactMap{$0.results}
            .eraseToAnyPublisher()
    }
}

extension DefaultArticlesRepository {
    enum API {
        case mostViewed
    }
}

extension DefaultArticlesRepository.API: APICall {
    var path: String {
        return "/mostpopular/v2/viewed/1.json?api-key=\(NetworkConstants.API_KEY)"
    }
    var method: String {
        return "GET"
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}
