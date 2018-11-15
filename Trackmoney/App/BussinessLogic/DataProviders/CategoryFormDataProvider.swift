// Для поствки данных в кортроллер форма Категорий

import CoreData

class CategoryFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: CategoryFormController?

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
    
    func loadData() {}
    
    
}
