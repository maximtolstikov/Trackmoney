// Для описания ДатаПровайдера у контроллера Счетов

import CoreData
import UIKit

class AccountsDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountsController?
    
    func loadData() {
        
        guard let accounts = dbManager?.get() else {
            assertionFailure()
            return
        }
        
        controller?.accounts = accounts as? [Account]
        controller?.navigationItem.title = "Total:"
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func change(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
}
