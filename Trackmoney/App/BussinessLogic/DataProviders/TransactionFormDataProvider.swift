// Доставки данных в контроллер формы транзакции

import CoreData

class TransactionFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    var accountDbManager: DBManagerProtocol?
    var categoryDbManager: DBManagerProtocol?
    weak var controller: TransactionFormController?
    
    func loadData() {
        
        guard let accounts = accountDbManager?.get() as? [Account] else {
            assertionFailure()
            return
        }
        controller?.accounts = accounts
        
        if let manager = categoryDbManager {
            guard let categories = manager.get() as? [CategoryTransaction] else {
                    assertionFailure()
                    return
            }
            controller?.categories = categories
        }
    }
    
    func save(message: [MessageKeyType: Any]) {
        
        let result = dbManager?.create(message: message)
        if let error = result?.1, let controller = controller {
            AlertManager().alertNeedCancel(
                controller: controller,
                title: error.error.rawValue,
                body: nil)
        }
        
    }
    
    func change(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
}
