//
//  ListView.swift
//  NewsReader
//
//  Created by MacBook on 25/08/2023.
//

import SwiftUI

struct ListView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("News Reader", displayMode: .large)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.articles {
        case .notRequested:
            notRequestedView
        case .isLoading:
            loadingView
        case let .loaded(articles):
            loadedView(articles)
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension ListView {
    var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.loadArticles)
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
            Button(action: {
                self.viewModel.articles.cancelLoading()
            }, label: { Text("Cancel loading") })
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.loadArticles()
        })
    }
}

// MARK: - Displaying Content

private extension ListView {
    func loadedView(_ articles: [DisplayItem]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(articles) { article in
                    DetailRow(titleLabel: Text(article.title), dateLabel: Text(article.date))
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListView.ViewModel())
    }
}
