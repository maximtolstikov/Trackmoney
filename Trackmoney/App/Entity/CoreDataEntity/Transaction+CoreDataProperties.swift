//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Maxim Tolstikov on 10/09/2018.
//
//
import CoreData
import Foundation


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var dateTransaction: NSDate
    @NSManaged public var sumTransaction: Int32
    @NSManaged public var typeTransaction: Int16
    @NSManaged public var nameAccount: String
    @NSManaged public var iconTransaction: String
    @NSManaged public var corAccount: String?
    @NSManaged public var nameCategory: String?

}
