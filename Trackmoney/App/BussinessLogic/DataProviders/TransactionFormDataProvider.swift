//swiftlint:disable force_cast
import CoreData

class TransactionFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    var accountDbManager: DBManagerProtocol?
    var categoryDbManager: DBManagerProtocol?
    weak var controller: TransactionFormController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        
        let result = accountDbManager?.get(all)
        
        guard let objects = result else {
            assertionFailure()
            return
        }
        
        let accounts = objects as! [Account]
        controller?.accounts = accounts
        
        let categoryType: CategoryType?
        var sortKey: SortKeys?
        
        if controller?.transactionType == .expense {
            categoryType = .expense
            sortKey = .expense
        } else if controller?.transactionType == .income {
            categoryType = .income
            sortKey = .income
        } else {
            categoryType = nil
        }
        
        if let type = categoryType?.rawValue {
            
            let predicat = NSPredicate(format: "type = %@", type)
            let result = categoryDbManager?.get(predicat)
            
            guard let objects = result else {
                assertionFailure()
                return
            }
            
            let categories = objects as! [CategoryTransaction]
            
            if let key = sortKey {
                
                let sortManager = CustomSortManager(key)
                let array = sortManager.sortedArray(categories)
                controller?.categories = array
                print(key)
            }
        }
    }
    
    // смотрит если есть id, то это изменение иначе создание
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
    
}
