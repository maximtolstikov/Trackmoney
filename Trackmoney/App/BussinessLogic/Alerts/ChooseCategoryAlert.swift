import UIKit

/// Алерт выбора Категории
class ChooseCategoryAlert: AlertManager {
    
    func show(categories: [CategoryTransaction],
              type: CategoryType,
              controller: UIViewController,
              comletion: @escaping (String) -> Void) {
        
        let arrayCategories = categories
        
        let titleAllert = NSLocalizedString("listCategoriesAlertTitle", comment: "")
        
        alertController = UIAlertController(
            title: titleAllert,
            message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: NSLocalizedString("cancelButton",
                                                            comment: ""), style: .cancel) { [weak self] _ in
            self?.alertController = nil
        }
        
        let add = UIAlertAction(title: NSLocalizedString("addCategory", comment: ""),
                                style: .default, handler: { _ in
            let viewController = CategoryFormControllerBuilder(typeCategory: type).viewController()
            controller.present(viewController, animated: true, completion: nil)
        })
        
        alertController.addAction(add)
        alertController.addAction(cancel)
        
        for category in arrayCategories {
            let action = UIAlertAction(title: category.name, style: .default, handler: { [weak self] _ in
                
                comletion(category.name)
                self?.alertController = nil
            })
            
            self.alertController.addAction(action)
        }
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
}
