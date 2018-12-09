import CoreData

class CategoryFormDataProvider: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: CategoryFormController?

    func save(message: [MessageKeyType: Any]) {
        
        let result: DBError?

        if message[.id] != nil {
            result = dbManager?.update(message)
        } else {
            result = dbManager?.create(message).1
        }

        if let error = result, let controller = controller {
            NeedCancelAlert().show(
                controller: controller,
                title: error.description,
                body: nil)
        }
    }
    
    func delete(with id: String) -> Bool {
        return false
    }
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result else {
            if controller != nil {
                // swiftlint:disable next force_unwrapping
                ShortAlert().show(controller: controller!,
                                  title: DBError.objectCanntGetFromBase.description,
                                  body: nil,
                                  style: .alert)
            }
            assertionFailure()
            return
        }
        
        let array = objects as? [CategoryTransaction]
        let type = controller?.typeCategory.rawValue
        let categories = array?.filter { $0.type == type }
        
        controller?.categories = categories
    }
    
}
