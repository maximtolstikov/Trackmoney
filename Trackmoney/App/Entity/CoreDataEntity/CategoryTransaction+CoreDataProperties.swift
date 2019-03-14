//
//  CategoryTransaction+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 11/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
//


import CoreData
import Foundation

extension CategoryTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryTransaction> {
        return NSFetchRequest<CategoryTransaction>(entityName: "CategoryTransaction")
    }

    @NSManaged public var icon: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var child: NSSet?
    @NSManaged public var parent: CategoryTransaction?

}

// MARK: - Generated accessors for child
extension CategoryTransaction {

    @objc(addChildObject:)
    @NSManaged public func addToChild(_ value: CategoryTransaction)

    @objc(removeChildObject:)
    @NSManaged public func removeFromChild(_ value: CategoryTransaction)

    @objc(addChild:)
    @NSManaged public func addToChild(_ values: NSSet)

    @objc(removeChild:)
    @NSManaged public func removeFromChild(_ values: NSSet)

}
