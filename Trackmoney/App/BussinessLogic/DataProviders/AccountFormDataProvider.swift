import CoreData

class AccountFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountFormController?
  
    func save(message: [MessageKeyType: Any]) {
        
        let result: DBError?
        
        if message[.id] != nil {
            result = dbManager?.update(message)
        } else {
            result = dbManager?.create(message).1
        }
        
        guard let controller = controller else { return }

        if let error = result {
            NeedCancelAlert().show(
                controller: controller,
                title: error.description,
                body: nil)
        }
        
    }
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {}
    
    func loadData() {}
    
    
}
