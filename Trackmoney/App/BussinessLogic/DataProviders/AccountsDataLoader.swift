// Для описания ДатаПровайдера у контроллера Счетов

import CoreData
import UIKit

class AccountsDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountsController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        
        let result = dbManager?.get(all)
        
        guard let accounts = result?.0 else {
            assertionFailure()
            return
        }
        
        controller?.accounts = accounts as? [Account]
        controller?.navigationItem.title = "Total:"
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func delete(with id: String) -> Bool {
        return false
    }
    
}
