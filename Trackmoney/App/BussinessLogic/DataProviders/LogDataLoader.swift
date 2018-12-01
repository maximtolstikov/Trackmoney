import CoreData

/// Описывает датаПровайдер у контроллера журнала
class LogDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: LogController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result?.0 else {
            if controller != nil {
                // swiftlint:disable next force_unwrapping
                ShortAlert().show(controller: controller!,
                                  title: result?.1?.error.rawValue,
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
        
        let error = dbManager?.delete(id)

        if error == nil, controller != nil {
            ShortAlert().show(
                controller: controller!,
                title: NSLocalizedString("transactionDelete", comment: ""),
                body: nil, style: .alert)
            return true
        } else {
            if controller != nil {
                NeedCancelAlert().show(
                    controller: controller!,
                    title: error!.error.rawValue,
                    body: nil)
            }
            return false
        }
    }
    
}
