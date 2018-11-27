// Для описания класса работы с данными для контроллера "Настройки Категорий"

//swiftlint:disable force_unwrapping

import CoreData
import UIKit

class CategorySettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: CategorySettingsController?
    
    func loadData() {
        
        guard let response = dbManager?.get() else {
            assertionFailure()
            return
        }
        
        guard let categories = response as? [CategoryTransaction] else {
            assertionFailure()
            return
        }
        
        let incomeCategories = categories.filter { $0.type == CategoryType.income.rawValue }
        let expenseCategories = categories
            .filter { $0.type == CategoryType.expense.rawValue }
        
        controller?.incomeCategories = incomeCategories
        controller?.expenseCategories = expenseCategories
        
    }
    
    func save(message: [MessageKeyType: Any]) {
        
        let result = dbManager?.create(message: message)
        
        if result?.0 != nil, controller != nil {
            
            ShortAlert().show(
                controller: controller!,
                title: AlertMessage.accountCreare.rawValue,
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
    
    func delete(with id: NSManagedObjectID) -> Bool {
        
        let message: [MessageKeyType: Any] = [.idCategory: id]
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
    
    func delete(message: [MessageKeyType: Any]) {}
    
}
