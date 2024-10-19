//
//  FavoritePost+CoreDataProperties.swift
//  
//
//  Created by Сергей Минеев on 10/19/24.
//
//

import Foundation
import CoreData


extension FavoritePost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePost> {
        return NSFetchRequest<FavoritePost>(entityName: "FavoritePost")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var date: Date?

}
