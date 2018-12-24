import CoreData
import UIKit

protocol DataProviderProtocol: AnyObject {
    
    var dbManager: DBManagerProtocol? { get }
    
    func loadData()
    func save(message: [MessageKeyType: Any])
    func delete(with id: String, completion: @escaping (Bool) -> Void)
}
