// Для описания класса работы с данными для контроллера "Настройки Категорий"

//swiftlint:disable force_unwrapping

import CoreData
import UIKit

class CategorySettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: CategorySettingsController?
    
    func loadData() {
        
        guard let categories = dbManager?.get() else {
            assertionFailure()
            return
        }
        
        controller?.categories = categories as? [CategoryTransaction]
        
    }
    
    func save(message: [MessageKeyType: Any]) {
        
        let result = dbManager?.create(message: message)
        
        if result?.0 != nil, controller != nil {
            
            AlertManager().shortNotification(
                controller: controller!,
                title: AlertMessage.accountCreare.rawValue,
                body: nil, style: .alert)
            
            loadData()
            
        } else {
            if result?.1 != nil, controller != nil {
                AlertManager().alertNeedCancel(
                    controller: controller!,
                    title: result?.1?.error.rawValue,
                    body: nil)
            }
        }
        
    }
    
    func delete(with id: NSManagedObjectID) -> Bool {
        
        let message: [MessageKeyType: Any] = [.idCategory: id]
        let error = dbManager?.delete(message: message)
        
        if error == nil, controller != nil {
            AlertManager().shortNotification(
                controller: controller!,
                title: AlertMessage.accountDeleted.rawValue,
                body: nil, style: .alert)
            return true
        } else {
            if error != nil, controller != nil {
                AlertManager().alertNeedCancel(
                    controller: controller!,
                    title: error!.error.rawValue,
                    body: nil)
            }
            return false
        }
        
    }
    
    func change(message: [MessageKeyType: Any]) {}
    
    func delete(message: [MessageKeyType: Any]) {}
    
}
