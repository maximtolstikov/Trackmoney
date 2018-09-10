//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Maxim Tolstikov on 10/09/2018.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var nameAccount: String
    @NSManaged public var sumAccount: Int32
    @NSManaged public var iconAccount: String?

}
