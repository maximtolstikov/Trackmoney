/// Для описания поставщика данных для контроллера форма Счета
import CoreData

class AccountFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountFormController?
  
    func save(message: [MessageKeyType: Any]) {
        
        let result: ErrorMessage?
        
        if message[.idAccount] != nil {
            result = dbManager?.change(message: message)
        } else {
            result = dbManager?.create(message: message).1
        }

        if let error = result, let controller = controller {
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
