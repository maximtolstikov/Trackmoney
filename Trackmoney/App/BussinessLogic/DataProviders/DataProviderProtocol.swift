import CoreData
import UIKit

protocol DataProviderProtocol: AnyObject {
    
    var dbManager: DBManagerProtocol? { get }
    typealias Result = (DBError?) -> Void
    
    func loadData()
    func save(message: Message, completion: @escaping Result)
    func delete(with id: String, completion: @escaping (Bool) -> Void)
}
