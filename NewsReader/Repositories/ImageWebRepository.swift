//
//  ImageWebRepository.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import Combine
import UIKit

protocol ImageWebRepository: WebRepository {
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error>
}

struct RealImageWebRepository: ImageWebRepository {
    let session: URLSession
    var baseURL: String = ""
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession) {
        self.session = session
    }
    
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        return download(rawImageURL: imageURL)
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    private func download(rawImageURL: URL) -> AnyPublisher<UIImage, Error> {
        let urlRequest = URLRequest(url: rawImageURL)
        return session.dataTaskPublisher(for: urlRequest)
            .requestData()
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIError.imageDeserialization
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
