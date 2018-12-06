import CoreData

class TransactionFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    var accountDbManager: DBManagerProtocol?
    var categoryDbManager: DBManagerProtocol?
    weak var controller: TransactionFormController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        
        let result = accountDbManager?.get(all)
        
        guard let accounts = result?.0 else {
            assertionFailure()
            return
        }
        
        controller?.accounts = accounts as? [Account]
        
        let categoryType: CategoryType?
        var sortKey: SortKeys?
        
        if controller?.transactionType == .expense {
            categoryType = .expense
            sortKey = .expense
        } else if controller?.transactionType == .income {
            categoryType = .income
            sortKey = .expense
        } else {
            categoryType = nil
        }
        
        if let type = categoryType?.rawValue {
            
            let predicat = NSPredicate(format: "type = %@", type)
            let result = categoryDbManager?
                .get(predicat) as? ([CategoryTransaction]?, ErrorMessage?)
            
            guard let objects = result?.0 else {
                assertionFailure()
                return
            }
            
            if let key = sortKey {
                
                let sortManager = CustomSortManager(key)
                let array = sortManager.sortedArray(objects)
                controller?.categories = array
            }
        }
    }
    
    // смотрит если есть id, то это изменение иначе создание
    func save(message: [MessageKeyType: Any]) {
        
        if message[.id] != nil {
            
            if let result = dbManager?.update(message) {
                showError(error: result)
            }
            
        } else {
            
            let result = dbManager?.create(message)
            if let error = result?.1 {
                showError(error: error)
            }
        }        
    }
    
    func delete(with id: String) -> Bool {
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
