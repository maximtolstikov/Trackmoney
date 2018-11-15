// Для описания датаПровайдера у контроллера журнала

import CoreData

class LogDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    func loadData() {
        
        guard let transactions = dbManager?.get() else {
            assertionFailure()
            return
        }
        controller?.transactions = transactions as? [Transaction]
        
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func change(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
}
