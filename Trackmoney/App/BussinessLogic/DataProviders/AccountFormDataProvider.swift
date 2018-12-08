import CoreData

class AccountFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountFormController?
  
    func save(message: [MessageKeyType: Any]) {
        
        let result: ErrorMessage?
        
        if message[.id] != nil {
            result = dbManager?.update(message)
        } else {
            result = dbManager?.create(message).1
        }

        if let error = result, let controller = controller {
            NeedCancelAlert().show(
                controller: controller,
                title: error.error.rawValue,
                body: nil)
        }
    }
    
    func delete(with id: String) -> Bool {
        return false
    }
    
    func loadData() {}
    
    
}
