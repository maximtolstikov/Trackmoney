import CoreData
import Foundation

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var category: String?
    @NSManaged public var corAccount: String?
    @NSManaged public var date: NSDate
    @NSManaged public var icon: String
    @NSManaged public var mainAccount: String
    @NSManaged public var note: String?
    @NSManaged public var sum: Int32
    @NSManaged public var type: Int16
    @NSManaged public var id: String

}
