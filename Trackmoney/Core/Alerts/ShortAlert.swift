import UIKit

/// Показывает короткий алерт
class ShortAlert: AlertManager {
    
    func show(
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
}
