//
//  Account+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 23/11/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//
import CoreData
import Foundation


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var icon: String?
    @NSManaged public var name: String
    @NSManaged public var sum: Int32
    @NSManaged public var type: String?

}
