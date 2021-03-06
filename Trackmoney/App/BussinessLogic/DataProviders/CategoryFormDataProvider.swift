import CoreData

class CategoryFormDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: CategoryFormController?
    
    func save(message: Message, completion: @escaping Result) {
        
        let result: DBError?
        
        if message[.id] != nil {
            result = dbManager?.update(message)
        } else {
            result = dbManager?.create(message).1
        }
        completion(result)
    }
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {}
    
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
