import UIKit

/// Показывает выбор типа транзакции
class ChooseTransactionAlert: AlertManager {
    
    func show(controller: UIViewController, nameAccount: String) {
        
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
        controller.present(formController, animated: true) {
            self.deinitAlert()
        }
    }
    
}
