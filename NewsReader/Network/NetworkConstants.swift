//
//  NetworkConstants.swift
//  NewsReader
//
//  Created by MacBook on 25/08/2023.
//

import Foundation

enum NetworkConstants {
    static let API_KEY = "cxkAtEZPG4qKNoyJs5icNe4OnQjxVitp"
    static let API_BASE_URL = "https://api.nytimes.com/svc"
    
    static let defaultImageUrl = "https://static.vecteezy.com/system/resources/thumbnails/006/299/370/original/world-breaking-news-digital-earth-hud-rotating-globe-rotating-free-video.jpg"
    
    static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
}
