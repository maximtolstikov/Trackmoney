import UIKit

/// Показывает выбор типа транзакции
class ChooseTransactionAlert: AlertManager {
    
    func show(controller: UIViewController, nameAccount: String, isTransfer: Bool) {
        
        guard nameAccount != "" else { return }
        
        alertController = UIAlertController(
            title: "\(nameAccount)",
            message: nil,
            preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancelTitle",
                                                            comment: ""),
                                   style: .cancel) { _ in
                                       self.alertController = nil
        }
        let expense = UIAlertAction(title: NSLocalizedString("expenseTitle", comment: ""),
                                    style: .default,
                                    handler: { _ in
                                        self.present(controller: controller,
                                                     type: TransactionType.expense,
                                                     name: nameAccount)
        })
        let income = UIAlertAction(title: NSLocalizedString("incomeTitle", comment: ""),
                                   style: .default,
                                   handler: { _ in
                                    self.present(controller: controller,
                                                 type: TransactionType.income,
                                                 name: nameAccount)
                                    
        })
        
        alertController.addAction(expense)
        alertController.addAction(income)
        
        if isTransfer {
            let transfer = UIAlertAction(title: NSLocalizedString("transferTitle", comment: ""),
                                         style: .default,
                                         handler: { _ in
                                            self.present(controller: controller,
                                                         type: TransactionType.transfer,
                                                         name: nameAccount)
            })
            alertController.addAction(transfer)
        }
        
        alertController.addAction(cancel)        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //вызывает контроллер после выбора варианта транзакции
    private func present(controller: UIViewController,
                         type: TransactionType,
                         name: String) {
        let formController = TransactionFormControllerBuilder()
            .viewController(transactionType: type)
        formController.topChooseButtonText = name
        controller.present(formController, animated: true, completion: nil)
    }
    
}
