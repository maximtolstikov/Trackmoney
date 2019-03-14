import CoreData

class AccountFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
      
    func save(message: [MessageKeyType: Any], completion: @escaping Result) {
        
        let result: DBError?
        
        if message[.id] != nil {
            result = dbManager?.update(message)
        } else {
            result = dbManager?.create(message).1
        }
        completion(result)
    }
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {}
    
    func loadData() {}
    
    
}
