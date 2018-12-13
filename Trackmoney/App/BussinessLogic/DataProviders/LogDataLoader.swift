import CoreData

/// Описывает датаПровайдер у контроллера журнала
class LogDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    var deleted = false
    
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
        
        let transactions = objects as? [Transaction]
        controller?.transactions = transactions?.reversed()
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func delete(with id: String) -> Bool {
        
        guard let controller = controller else { return false }
        
        AcceptAlert().show(controller: controller,
                           title: NSLocalizedString("acceptDeleteTitle",
                                                    comment: ""),
                           body: nil) { [unowned self] (flag) in
                            if flag {
                                let error = self.dbManager?.delete(id)
                                
                                if error == nil {
                                    
                                    self.deleted = true
                                    ShortAlert().show(
                                        controller: controller,
                                        title: NSLocalizedString("transactionDelete", comment: ""),
                                        body: nil,
                                        style: .alert)
                                    
                                } else {
                                    if error != nil {
                                        NeedCancelAlert().show(
                                            controller: controller,
                                            title: error!.description,
                                            body: nil)
                                    }
                                }
                            }
        }
        return deleted
    }
    
}
