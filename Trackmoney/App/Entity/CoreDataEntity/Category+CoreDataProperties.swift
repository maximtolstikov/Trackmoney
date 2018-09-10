//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Maxim Tolstikov on 10/09/2018.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var nameCategory: String
    @NSManaged public var iconCategory: String?

}
