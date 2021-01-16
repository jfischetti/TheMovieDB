//
//  CoreDataStack.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack: DataManager {

    let ContentEntityName = "Content"
    let ContentEntityMovieType = "movie"
    let ContentEntityTVType = "tv"
    let LastCategoryCacheKey = "lastCategory"
    let moduleName = "TheMovieDB"

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let persistantStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistantStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError("Persistent store error! \(error)")
        }

        return coordinator
    }()

    // A context just for saving data to the databse on a private queue
    private lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()

    // A context for saving data to the saveManagedObjectContext on the main queue
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.parent = self.saveManagedObjectContext

        return managedObjectContext
    }()

    func saveMainContext() {
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else {
            return
        }

        managedObjectContext.performAndWait {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }

        saveManagedObjectContext.perform {
            do {
                try self.saveManagedObjectContext.save()
            } catch {
                fatalError("Error saving private managed object context! \(error)")
            }
        }
    }

    func getAllContents() -> [ContentProtocol] {
        let coreDataContents = getAllCoreDataContents()

        let contents = coreDataContents.map { element -> ContentProtocol in
            if element.type == ContentEntityMovieType {
                return contentToMovie(content: element)
            } else {
                return contentToTV(content: element)
            }
        }

        return contents
    }

    func upsertContent(content: ContentProtocol, with isFavorite: Bool?, for contentType: ContentType?)
    {
        var coreDataContent = getCoreDataContent(by: content.id!)

        // if no data is found then create a new entity
        if coreDataContent == nil {
            let entity = NSEntityDescription.entity(forEntityName: ContentEntityName, in: self.managedObjectContext)!
            coreDataContent = Content(entity: entity, insertInto: self.managedObjectContext)
        }

        coreDataContent?.id = Int32(content.id!)
        coreDataContent?.title = content.title
        coreDataContent?.posterPath = content.posterPath
        coreDataContent?.type = content as? Movie != nil ? ContentEntityMovieType : ContentEntityTVType

        if let contentType = contentType {
            // set content type if its passed in
            coreDataContent?.contentType = contentType.rawValue
        }

        if let isFavorite = isFavorite {
            // set favorite if its passed in
            coreDataContent?.favorite = isFavorite
        }

        self.saveMainContext()
    }

    func removeContent(content: ContentProtocol) {

        let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", content.id!)
        let coreDataContents = try! self.managedObjectContext.fetch(fetchRequest)
        self.managedObjectContext.delete(coreDataContents.first!)

        self.saveMainContext()
    }

    func getContent(by id: Int) -> ContentProtocol? {

        guard let content = getCoreDataContent(by: id) else {
            return nil
        }

        if content.type == ContentEntityMovieType {
            return contentToMovie(content: content)
        } else {
            return contentToTV(content: content)
        }
    }

    func isFavoriteContent(content: ContentProtocol) -> Bool {
        if let coreDateContent = getCoreDataContent(by: content.id!) {
            return coreDateContent.favorite
        }

        return false
    }

    private func getAllCoreDataContents() -> [Content] {
        let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
        let coreDataContents = try! self.managedObjectContext.fetch(fetchRequest)

        return coreDataContents
    }

    private func getCoreDataContent(by id: Int) -> Content? {
        let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let coreDataContents = try! self.managedObjectContext.fetch(fetchRequest)

        guard coreDataContents.count == 1  else {
            return nil
        }

        return coreDataContents.first
    }

    func cacheFeatureCategory(contentType: ContentType, with contents: [ContentProtocol]) {
        let defaults = UserDefaults.standard
        defaults.set(contentType.rawValue, forKey: LastCategoryCacheKey)

        // clear old cached values
        clearFeaturedCategoryCache()

        // cache new values
        contents.forEach { content in
            upsertContent(content: content, with: nil, for: contentType)

            DispatchQueue.global(qos: .background).async {
                // cache poster image
                if let url = content.posterUrl(), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    let id = String(content.id!)
                    ImageCacheManager.shared.cacheImage(image: image, with: id)
                }
            }
        }
    }

    func clearFeaturedCategoryCache() {
        let contents = getAllCoreDataContents()
        contents.forEach { content in

            // delete any associated cached images
            let id = String(content.id)
            ImageCacheManager.shared.deleteImage(with: id)

            if let _ = content.contentType, content.favorite == false {
                // delete cached content if its marked for a feature category and its not favorited
                self.managedObjectContext.delete(content)
            } else if let _ = content.contentType {
                // remove contentType from contents that are favorited
                content.contentType = nil
            }
        }

        self.saveMainContext()
    }

    func getCachedFeatureCategory() -> (ContentType?, [ContentProtocol]?) {
        let defaults = UserDefaults.standard
        var contentType: ContentType?
        var contents: [ContentProtocol]?

        if let category = defaults.string(forKey: LastCategoryCacheKey) {
            contentType = ContentType(rawValue: category)

            let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "contentType == %@", contentType!.rawValue)
            let coreDataContents = try! self.managedObjectContext.fetch(fetchRequest)
            contents = coreDataContents.map { element -> ContentProtocol in
                if element.type == ContentEntityMovieType {
                    return contentToMovie(content: element)
                } else {
                    return contentToTV(content: element)
                }
            }
        }

        return (contentType, contents)
    }

    func contentToMovie(content: Content) -> Movie {
        return Movie(id: Int(content.id), title: content.title, posterPath: content.posterPath)
    }

    func contentToTV(content: Content) -> TV {
        return TV(id: Int(content.id), title: content.title, overview: nil, posterPath: content.posterPath, voteAverage: nil)
    }
}
