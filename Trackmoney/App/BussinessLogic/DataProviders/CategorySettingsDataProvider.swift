import CoreData
import UIKit

class CategorySettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: CategorySettingsController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result else {
            if controller != nil {
                // swiftlint:disable next force_unwrapping
                ShortAlert().show(controller: controller!,
                                  title: result?.description,
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
    
    func save(message: Message, completion: @escaping Result) {}
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {
        
        guard let controller = controller else { return }
        
        AcceptAlert().show(controller: controller,
                           title: NSLocalizedString("acceptDeleteTitle",
                                                    comment: ""),
                           body: nil) { [unowned self] (flag) in
                            if flag {
                                let error = self.dbManager?.delete(id, force: false)
                                
                                if error == nil {

                                    ShortAlert().show(
                                        controller: controller,
                                        title: NSLocalizedString("categoryDelete", comment: ""),
                                        body: nil,
                                        style: .alert)
                                    
                                    completion(true)
                                    
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
    }
    
}
