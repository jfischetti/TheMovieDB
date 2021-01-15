//
//  Content+CoreDataProperties.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var type: String?

}

extension Content : Identifiable {

}
