/// Для поствки данных в кортроллер форма Категорий
import CoreData

class CategoryFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: CategoryFormController?

    func save(message: [MessageKeyType: Any]) {
        
        let result: ErrorMessage?
        
        if message[.idCategory] != nil {
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
    
    func loadData() {
        
        let array = dbManager?.get() as? [CategoryTransaction]
        let type = controller?.typeCategory.rawValue
        let categories = array?.filter { $0.type == type }
        
        controller?.categories = categories
    }
    
}
