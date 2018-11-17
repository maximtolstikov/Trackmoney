//
//  Account+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 17/11/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var iconAccount: String?
    @NSManaged public var nameAccount: String
    @NSManaged public var sumAccount: Int32

}
