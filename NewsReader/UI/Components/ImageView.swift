//
//  ImageView.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import SwiftUI
import Combine

struct ImageView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.image {
        case .notRequested:
            notRequestedView
        case .isLoading:
            loadingView
        case let .loaded(image):
            loadedView(image)
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Side Effects

private extension ImageView.ViewModel {
    func loadImage() {
        imageService
            .load(image: loadableSubject(\.image), url: imageURL)
    }
}

// MARK: - Content

private extension ImageView {
    var notRequestedView: some View {
        Text("").onAppear {
            self.viewModel.loadImage()
        }
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    func failedView(_ error: Error) -> some View {
        Text("Unable to load image")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    func loadedView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

// MARK: - ViewModel

extension ImageView {
    class ViewModel: ObservableObject {
        
        // State
        let imageURL: URL
        @Published var image: Loadable<UIImage>
        
        // Misc
        private var cancelBag = CancelBag()
        
        private let imageService = RealImagesService(
            webRepository:
                RealImageWebRepository(
                    session: NetworkConstants.urlSession),
            fileCache: ImageFileCacheRepository()
        )
        
        init(imageURL: URL, image: Loadable<UIImage> = .notRequested) {
            self.imageURL = imageURL
            self._image = .init(initialValue: image)
        }
    }
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ImageView.ViewModel(imageURL: URL(string: NetworkConstants.defaultImageUrl)!)
        ImageView(viewModel: viewModel)
    }
}
#endif
