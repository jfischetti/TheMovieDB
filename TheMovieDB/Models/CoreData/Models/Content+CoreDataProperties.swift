//
//  Content+CoreDataProperties.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/16/21.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var id: Int32
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var contentType: String?
    @NSManaged public var favorite: Bool

}

extension Content : Identifiable {

}
