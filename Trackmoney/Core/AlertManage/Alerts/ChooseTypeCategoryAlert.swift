import UIKit

/// Показывает Алерт выбора транзакций
class ChooseTypeCategoryAlert: AlertManager {
    
    func show(controller: UIViewController) {
        
        alertController = UIAlertController(title: NSLocalizedString("chooseTypeCategory", comment: ""),
                                            message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("titleCancelButton", comment: ""),
                                   style: .cancel, handler: nil)
        
        let expense = UIAlertAction(title: NSLocalizedString("expenseTitle", comment: ""),
                                    style: .default,
                                    handler: { _ in
                                        self.presentController(controller: controller, type: .expense)
        })
        
        let income = UIAlertAction(title: NSLocalizedString("incomeTitle", comment: ""),
                                   style: .default,
                                   handler: { _ in
                                    self.presentController(controller: controller, type: .income)
                                    
        })
        
        alertController.addAction(expense)
        alertController.addAction(income)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //вызывает CategoryFormController после выбора типа Категории
    private func presentController(controller: UIViewController, type: CategoryType) {
        
        let formController = CategoryFormControllerBilder(typeCategory: type).viewController()
        controller.present(formController, animated: true, completion: nil)
    }
}
