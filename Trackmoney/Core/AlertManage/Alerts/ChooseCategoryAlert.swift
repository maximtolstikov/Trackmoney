import UIKit

/// Алерт выбора Категории
class ChooseCategoryAlert: AlertManager {
    
    func show(categories: [CategoryTransaction],
              controller: UIViewController,
              comletion: @escaping (String) -> Void) {
        
        let arrayCategories = categories
        
        let titleAllert = NSLocalizedString("listCategoriesAlertTitle", comment: "")
        
        self.alertController = UIAlertController(
            title: titleAllert,
            message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.alertController.addAction(cancel)
        
        for category in arrayCategories {
            let action = UIAlertAction(title: category.nameCategory, style: .default, handler: { [weak self] _ in
                
                comletion(category.nameCategory)
                self?.alertController = nil
            })
            
            self.alertController.addAction(action)
        }
        
        controller.present(self.alertController, animated: true, completion: nil)
        
    }
    
}
