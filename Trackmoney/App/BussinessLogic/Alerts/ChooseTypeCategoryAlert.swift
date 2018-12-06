import UIKit

/// Показывает Алерт выбора транзакций
class ChooseTypeCategoryAlert: AlertManager {
    
    func show(controller: UIViewController) {
        
        alertController = UIAlertController(title: NSLocalizedString("chooseTypeCategory", comment: ""),
                                            message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("cancelButton",
                                                            comment: ""),
                                   style: .cancel) {[weak self] _ in
                                    self?.alertController = nil
        }
        
        let expense = UIAlertAction(title: NSLocalizedString("expenseTitle", comment: ""),
                                    style: .default) { _ in
                                        self.present(controller: controller, type: .expense)
        }
        
        let income = UIAlertAction(title: NSLocalizedString("incomeTitle", comment: ""),
                                   style: .default) { _ in
                                    self.present(controller: controller, type: .income)
        }
        
        alertController.addAction(expense)
        alertController.addAction(income)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //вызывает CategoryFormController после выбора типа Категории
    private func present(controller: UIViewController, type: CategoryType) {
        
        let formController = CategoryFormControllerBuilder(typeCategory: type)
            .viewController()
        controller.present(formController, animated: true, completion: nil)
    }
}
