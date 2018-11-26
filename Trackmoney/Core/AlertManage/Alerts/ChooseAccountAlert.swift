import UIKit

/// Показывает выбор счетов
class ChooseAccountAlert: AlertManager {

    func show(accounts: [Account],
              controller: UIViewController,
              comletion: @escaping (String) -> Void) {
        
        let arrayAccounts = accounts
        
        let titleAllert = NSLocalizedString("listAccountsAlertTitle",
                                            comment: "")
        
        self.alertController = UIAlertController(
            title: titleAllert,
            message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: NSLocalizedString("cancelButton",
                                                     comment: ""),
                                   style: .cancel, handler: nil)
        self.alertController.addAction(cancel)
        
        for (account) in arrayAccounts {
            let action = UIAlertAction(title: account.name,
                                       style: .default,
                                       handler: { [weak self] _ in
                
                comletion(account.name)
                self?.alertController = nil
            })
            
            self.alertController.addAction(action)
        }
        
        controller.present(self.alertController, animated: true, completion: nil)
        
    }
}
