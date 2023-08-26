//
//  ListViewModel.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import SwiftUI
import Combine

// MARK: - ViewModel

extension ListView {
    class ViewModel: ObservableObject {
        
        // State
        @Published var articles: Loadable<[DisplayItem]> = .notRequested
        private let articleService = DefaultArticleService(
            webRepository: DefaultArticlesRepository(
                session: NetworkConstants.urlSession,
                baseURL: NetworkConstants.API_BASE_URL
            ),
            dbRepository: RealArticlesDBRepository(
                persistentStore: CoreDataStack(version: CoreDataStack.Version.actual)
            )
        )
        
        // Misc
        private var cancelBag = CancelBag()
        
        // MARK: - Side Effects
        
        func loadArticles() {
            articleService.get(articles: loadableSubject(\.articles))
        }
    }
}
