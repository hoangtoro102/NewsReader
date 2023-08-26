//
//  Models+CoreData.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import Foundation
import CoreData

extension ArticleMO: ManagedEntity { }
extension MediaMO: ManagedEntity { }
extension MetadataMO: ManagedEntity { }

extension Article {
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> ArticleMO? {
        guard let article = ArticleMO.insertNew(in: context)
            else { return nil }
        article.id = id ?? 0
        article.title = title
        article.publishedDate = publishedDate
        let storedMedia = (media ?? []).compactMap { $0.store(in: context) }
        article.media = NSSet(array: storedMedia)
        return article
    }
    
    init?(managedObject: ArticleMO) {
        let media = (managedObject.media ?? NSSet())
            .toArray(of: MediaMO.self)
            .compactMap { Media(managedObject: $0) }
        
        self.init(
            id: managedObject.id,
            title: managedObject.title,
            publishedDate: managedObject.publishedDate,
            media: media
        )
    }
}

extension Media {
    
    init?(managedObject: MediaMO) {
        let metadata = (managedObject.mediaMetadata ?? NSSet())
            .toArray(of: MetadataMO.self)
            .compactMap { Metadata(managedObject: $0) }
        
        self.init(type: managedObject.type, mediaMetadata: metadata)
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> MediaMO? {
        guard let media = MediaMO.insertNew(in: context)
            else { return nil }
        media.type = type
        let storedMetadata = (mediaMetadata ?? []).compactMap { $0.store(in: context) }
        media.mediaMetadata = NSSet(array: storedMetadata)
        return media
    }
}
                
extension Metadata {
    
    init?(managedObject: MetadataMO) {
        guard let url = managedObject.url
            else { return nil }
        self.init(url: url)
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> MetadataMO? {
        guard let metadata = MetadataMO.insertNew(in: context)
            else { return nil }
        metadata.url = url
        return metadata
    }
}
