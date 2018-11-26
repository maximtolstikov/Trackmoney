import UIKit

/// Алерт требующий закрытия
class NeedCancelAlert: AlertManager {
    
    //показывает уведомление требующее подтверждения
    func show(
        controller: UIViewController,
        title: String?,
        body: String?) {
        
        alertController = UIAlertController(
            title: title ?? "",
            message: body ?? "",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancelButton",
                                                            comment: ""),
                                   style: .cancel) {[weak self] _ in
            self?.deinitAlert()
        }
        
        alertController.addAction(cancel)
        controller.present(alertController, animated: true, completion: nil)
        
    }

}
