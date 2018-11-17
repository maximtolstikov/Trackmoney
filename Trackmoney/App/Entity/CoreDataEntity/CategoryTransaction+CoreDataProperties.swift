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
    @NSManaged public var type: Bool
    @NSManaged public var group: NSSet?

}

// MARK: - Generated accessors for group
extension CategoryTransaction {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: CategoryTransaction)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: CategoryTransaction)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}
