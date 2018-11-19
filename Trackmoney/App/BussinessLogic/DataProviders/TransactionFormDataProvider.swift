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
    
    // смотрит если есть id, то это изменение иначе создание
    func save(message: [MessageKeyType: Any]) {
        
        if message[.idTransaction] != nil {
            
            if let result = dbManager?.change(message: message) {
                showError(error: result)
            }
            
        } else {
            
            let result = dbManager?.create(message: message)
            if let error = result?.1 {
                showError(error: error)
            }
            
        }
        
    }
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
    private func showError(error: ErrorMessage) {
        
        guard let controller = controller else { return }
        
        NeedCancelAlert().show(
            controller: controller,
            title: error.error.rawValue,
            body: nil)
    }
    
}
