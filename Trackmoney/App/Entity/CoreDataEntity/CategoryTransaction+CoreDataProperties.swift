//
//  CategoryTransaction+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 17/11/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryTransaction> {
        return NSFetchRequest<CategoryTransaction>(entityName: "CategoryTransaction")
    }

    @NSManaged public var iconCategory: String?
    @NSManaged public var nameCategory: String
    @NSManaged public var typeCategory: String
    @NSManaged public var groupCategory: NSSet?

}

// MARK: - Generated accessors for groupCategory
extension CategoryTransaction {

    @objc(addGroupCategoryObject:)
    @NSManaged public func addToGroupCategory(_ value: CategoryTransaction)

    @objc(removeGroupCategoryObject:)
    @NSManaged public func removeFromGroupCategory(_ value: CategoryTransaction)

    @objc(addGroupCategory:)
    @NSManaged public func addToGroupCategory(_ values: NSSet)

    @objc(removeGroupCategory:)
    @NSManaged public func removeFromGroupCategory(_ values: NSSet)

}
