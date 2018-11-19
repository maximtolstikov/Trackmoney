// Для описания поставщика данных для контроллера форма Счета

import CoreData

class AccountFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountFormController?
  
    func save(message: [MessageKeyType: Any]) {
        
        let result = dbManager?.create(message: message)
        if let error = result?.1, let controller = controller {
            NeedCancelAlert().show(
                controller: controller,
                title: error.error.rawValue,
                body: nil)
        }
        
    }
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
    func loadData() {}
    
    
}
