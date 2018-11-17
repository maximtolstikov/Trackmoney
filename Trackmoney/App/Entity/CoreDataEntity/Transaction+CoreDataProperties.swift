//
//  Transaction+CoreDataProperties.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 17/11/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var corAccount: String?
    @NSManaged public var dateTransaction: NSDate
    @NSManaged public var iconTransaction: String
    @NSManaged public var nameAccount: String
    @NSManaged public var nameCategory: String?
    @NSManaged public var sumTransaction: Int32
    @NSManaged public var typeTransaction: Int16

}
