// Для описания класса работы с данными для контроллера "Настройки счетов"


import CoreData
import UIKit

class AccountsSettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: AccountsSettingsController?
    
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

        controller?.accounts = objects as? [Account]
    }
    
    func save(message: [MessageKeyType: Any]) {
        
        let result = dbManager?.create(message)

        if result?.0 != nil, controller != nil {

            ShortAlert().show(
                controller: controller!,
                title: NSLocalizedString("accountCreate", comment: ""),
                body: nil, style: .alert)

            loadData()

        } else {
            if result?.1 != nil, controller != nil {
                NeedCancelAlert().show(
                    controller: controller!,
                    title: result?.1?.error.rawValue,
                    body: nil)
            }
        }
        
    }
    
    func delete(with id: String) -> Bool {
        
        let error = dbManager?.delete(id)

        if error == nil, controller != nil {
            ShortAlert().show(
                controller: controller!,
                title: NSLocalizedString("accountDelete", comment: ""),
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
