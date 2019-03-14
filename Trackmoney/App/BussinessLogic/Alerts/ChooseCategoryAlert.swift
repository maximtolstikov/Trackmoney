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
        let cancel = UIAlertAction(title: NSLocalizedString("cancelTitle",
                                                            comment: ""),
                                   style: .cancel) { [weak self] _ in
            self?.alertController = nil
        }
        
        let add = UIAlertAction(title: NSLocalizedString("addTitle", comment: ""),
                                style: .default, handler: { _ in
            let viewController = CategoryFormControllerBuilder(typeCategory: type).viewController()
            controller.present(viewController, animated: true, completion: nil)
        })
        
        for category in arrayCategories {
            let action = UIAlertAction(title: category.name, style: .default, handler: { [weak self] _ in
                
                comletion(category.name)
                self?.alertController = nil
            })
            
            self.alertController.addAction(action)
        }
        
        let empty = UIAlertAction(title: NSLocalizedString("emptyTitle", comment: ""),
                                  style: .default) { _ in
                                    comletion(NSLocalizedString("emptyTitle",
                                                                comment: ""))
        }
        
        alertController.addAction(empty)
        alertController.addAction(add)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
}
