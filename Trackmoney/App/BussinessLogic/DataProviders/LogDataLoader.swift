// Для описания датаПровайдера у контроллера журнала

import CoreData

class LogDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    func loadData() {
        
        guard let transactions = dbManager?.get() else {
            assertionFailure()
            return
        }
        controller?.transactions = transactions as? [Transaction]
        
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func change(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        
        let message: [MessageKeyType: Any] = [.idTransaction: id]
        let error = dbManager?.delete(message: message)
        
        if error == nil, controller != nil {
            ShortAlert().show(
                controller: controller!,
                title: AlertMessage.accountDeleted.rawValue,
                body: nil, style: .alert)
            return true
        } else {
            if error != nil, controller != nil {
                NeedCancelAlert().show(
                    controller: controller!,
                    title: error!.error.rawValue,
                    body: nil)
            }
            return false
        }
        
    }
    
}
