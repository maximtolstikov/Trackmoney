//
//  Account+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/11/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//
import CoreData
import Foundation

extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var iconAccount: String?
    @NSManaged public var name: String
    @NSManaged public var sumAccount: Int32

}
