import UIKit

/// Для переименования Счетов и Категорий
class RenameEntity: AlertManager {
    
    func show(controller: UIViewController, entyty: DBEntity) {
        
        alertController = UIAlertController(title: NSLocalizedString("renameTitle",
                                                                     comment: ""),
                                            message: "",
                                            preferredStyle: .alert)
        let decline = UIAlertAction(title: NSLocalizedString("decline",
                                                            comment: ""),
                                   style: .cancel) {[weak self] _ in
                                    self?.alertController = nil
        }
        let approve = UIAlertAction(title: NSLocalizedString("approve",
                                                          comment: ""),
                                 style: .default) { _ in
                                    self.present(controller: controller, entity: entyty)
                                    self.alertController = nil
        }

        alertController.addAction(decline)
        alertController.addAction(approve)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    private func present(controller: UIViewController, entity: DBEntity) {
        
        if entity is Account {
            
            //swiftlint:disable next force_cast
            let account = entity as! Account
            
            let formController = AccountFormControllerBuilder().viewController()
            formController.accountForUpdate = account
            controller.present(formController, animated: true, completion: nil)
            
        } else {
            
            //swiftlint:disable next force_cast
            let category = entity as! CategoryTransaction
            
            guard let type = CategoryType(rawValue: category.type) else { return }
            
            let formController = CategoryFormControllerBuilder(typeCategory: type)
                .viewController()
            formController.categotyForUpdate = category
            controller.present(formController, animated: true, completion: nil)
        }
    }
}
