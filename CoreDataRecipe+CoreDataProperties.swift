//
//  CoreDataRecipe+CoreDataProperties.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/09/29.
//
//

import Foundation
import CoreData


extension CoreDataRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataRecipe> {
        return NSFetchRequest<CoreDataRecipe>(entityName: "CoreDataRecipe")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var servings: Int32
    @NSManaged public var readyInMinutes: Int64
    @NSManaged public var sourceUrl: String?

}

extension CoreDataRecipe : Identifiable {

}
