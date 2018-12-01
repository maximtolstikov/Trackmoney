import CoreData
import UIKit

class CategorySettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: CategorySettingsController?
    
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
        
        guard let categories = objects as? [CategoryTransaction] else {
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
        
        let result = dbManager?.create(message)

        if result?.0 != nil, controller != nil {

            ShortAlert().show(
                controller: controller!,
                title: NSLocalizedString("categoryCreate", comment: ""),
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
                title: NSLocalizedString("categoryDelete", comment: ""),
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
