//
//  ImagesService.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import Combine
import Foundation
import SwiftUI

protocol ImagesService {
    func load(image: LoadableSubject<UIImage>, url: URL?)
}

struct RealImagesService: ImagesService {
    
    let webRepository: ImageWebRepository
    let fileCache: ImageCacheRepository
    
    init(webRepository: ImageWebRepository, fileCache: ImageCacheRepository) {
        self.webRepository = webRepository
        self.fileCache = fileCache
    }
    
    func load(image: LoadableSubject<UIImage>, url: URL?) {
        guard let url = url else {
            image.wrappedValue = .notRequested; return
        }
        let cancelBag = CancelBag()
        image.wrappedValue = .isLoading(last: image.wrappedValue.value, cancelBag: cancelBag)
        self.fileCache.cachedImage(for: url.imageCacheKey)
            .catch { _ in
                self.webRepository.load(imageURL: url)
            }
            .sinkToLoadable {
                if let image = $0.value {
                    self.fileCache.cache(image: image, key: url.imageCacheKey)
                }
                image.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
}

extension URL {
    var imageCacheKey: ImageCacheKey {
        return absoluteString
    }
}
