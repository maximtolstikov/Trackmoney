// Для определения интерфейса загрузчика данных

import CoreData
import UIKit

protocol DataProviderProtocol: AnyObject {
    
    var dbManager: DBManagerProtocol? { get }
    
    func loadData()
    func save(message: [MessageKeyType: Any])
    func change(message: [MessageKeyType: Any])
    func delete(with id: NSManagedObjectID) -> Bool
    
}
