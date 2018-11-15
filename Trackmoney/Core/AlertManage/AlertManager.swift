// Для описания методов вызова AlertControllre

import UIKit

class AlertManager {
    
    var alertController: UIAlertController!
    let timeIntervalShortNotification = 300
    
    // показывает выбор транзакций
    func showSelectTransaction(controller: UIViewController, nameAccount: String) {
        
        guard nameAccount != "" else { return }        
        
        alertController = UIAlertController(title: "\(nameAccount)", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let expense = UIAlertAction(title: "Expense",
                                    style: .default,
                                    handler: { _ in
            self.presentTransactionFormController(controller: controller,
                                                type: TransactionType.expense,
                                                name: nameAccount)
        })
        
        let income = UIAlertAction(title: "Income",
                                   style: .default,
                                   handler: { _ in
            self.presentTransactionFormController(controller: controller,
                                                 type: TransactionType.income,
                                                 name: nameAccount)
        
        })
        
        let transfer = UIAlertAction(title: "Transfer",
                                     style: .default,
                                     handler: {_ in
            self.presentTransactionFormController(controller: controller,
                                                  type: TransactionType.transfer,
                                                  name: nameAccount)
        })
        
        alertController.addAction(expense)
        alertController.addAction(income)
        alertController.addAction(transfer)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //вызывает TransactionFormController после выбора варианта транзакции
    private func presentTransactionFormController(controller: UIViewController,
                                                  type: TransactionType,
                                                  name: String) {
        let formController = TransactionFormControllerBilder()
            .viewController(transactionType: type)
        formController.topChooseButtonName = name        
        controller.present(formController, animated: true, completion: nil)
    }
    
    // показывает уведомление в течении установленного времени
    func shortNotification(
        controller: UIViewController,
        title: String?,
        body: String?,
        style: UIAlertController.Style) {
        
        alertController = UIAlertController(
            title: title ?? "",
            message: body ?? "",
            preferredStyle: style)
        
        controller.present(alertController, animated: true) {
            self.delay(self.timeIntervalShortNotification, closure: {
                self.deinitAlert()
            })
        }
        
    }
        
    //показывает уведомление требующее подтверждения
    func alertNeedCancel(
        controller: UIViewController,
        title: String?,
        body: String?) {
        
        alertController = UIAlertController(
            title: title ?? "",
            message: body ?? "",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.deinitAlert()
        }
        
        alertController.addAction(cancel)
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    
    // отложенно выполняет closure
    private func delay(_ delay: Int, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            closure()
        }
    }
    
    // закрывает контроллер
    private func deinitAlert() {
        alertController.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    
    // показывает выбор счета из списка 
    func showSelectAccounts(accounts: [Account],
                            controller: UIViewController,
                            comletion: @escaping (String) -> Void) {
        
        let arrayAccounts = accounts
        
        let titleAllert = NSLocalizedString("listAccountsAlertTitle", comment: "")
        
        self.alertController = UIAlertController(
            title: titleAllert,
            message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.alertController.addAction(cancel)
        
        for (account) in arrayAccounts {
            let action = UIAlertAction(title: account.nameAccount, style: .default, handler: { [weak self] _ in
                
                comletion(account.nameAccount)
                self?.alertController = nil
            })
            
            self.alertController.addAction(action)
        }
        
        controller.present(self.alertController, animated: true, completion: nil)
        
    }
    
    // показывает выбор Категории из списка
    func showSelectCategories(categories: [CategoryTransaction],
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
