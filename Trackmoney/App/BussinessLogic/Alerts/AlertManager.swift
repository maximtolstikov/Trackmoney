import UIKit

/// Родительский класс Алертов
class AlertManager {
    
    var alertController: UIAlertController!
    let timeIntervalShortNotification = 1000
    
    // отложенно выполняет closure
    func delay(_ delay: Int, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            closure()
        }
    }
    
    // закрывает контроллер
    func deinitAlert() {
        alertController.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
}
