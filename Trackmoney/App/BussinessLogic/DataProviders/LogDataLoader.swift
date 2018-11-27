import CoreData

/// Описывает датаПровайдер у контроллера журнала
class LogDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    func loadData() {
        
        guard let objects = dbManager?.get() else {
            assertionFailure()
            return
        }
        let transactions = objects as? [Transaction]
        controller?.transactions = transactions?.reversed()
        
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        
        let message: [MessageKeyType: Any] = [.idTransaction: id]
        let error = dbManager?.delete(message: message)
        
        //swiftlint:disable force_unwrapping
        if error == nil, controller != nil {
            ShortAlert().show(
                controller: controller!,
                title: NSLocalizedString("transactionDelete", comment: ""),
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
