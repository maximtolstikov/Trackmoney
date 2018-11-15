//
//  CategoryTransaction+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 02/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

import CoreData
import Foundation

extension CategoryTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryTransaction> {
        return NSFetchRequest<CategoryTransaction>(entityName: "CategoryTransaction")
    }

    @NSManaged public var iconCategory: String?
    @NSManaged public var nameCategory: String

}
