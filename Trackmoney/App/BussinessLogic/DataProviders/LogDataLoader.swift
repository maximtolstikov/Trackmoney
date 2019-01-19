import CoreData

/// Описывает датаПровайдер у контроллера журнала
class LogDataLoader: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result, let controller = controller else {
            assertionFailure()
            return
        }
        
        let transactions = objects as? [Transaction]
        controller.transactions = transactions?.reversed()
    }
    
    func save(message: [MessageKeyType: Any], completion: @escaping Result) {}
    
    //swiftlint:disable force_unwrapping
    func delete(with id: String, completion: @escaping (Bool) -> Void) {
        
        guard let controller = controller else { return }
        
        AcceptAlert().show(controller: controller,
                           title: NSLocalizedString("acceptDeleteTitle", comment: ""),
                           body: nil) { [unowned self] (flag) in
                            if flag {
                                let error = self.dbManager?.delete(id, force: false)
                                
                                if error == nil {
                                    
                                    ShortAlert().show(
                                        controller: controller,
                                        title: NSLocalizedString("transactionDelete", comment: ""),
                                        body: nil,
                                        style: .alert)
                                    
                                    completion(true)
                                    
                                } else if error != nil {
                                    NeedCancelAlert().show(
                                        controller: controller,
                                        title: error!.description,
                                        body: nil)
                                }
                            }
        }
    }
    
}
