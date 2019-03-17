import UIKit

class AcceptAlert: AlertManager {
    
    func show(
        controller: UIViewController,
        title: String?,
        body: String?,
        completion: @escaping (Bool) -> Void) {
        
        alertController = UIAlertController(
            title: title ?? "",
            message: body ?? "",
            preferredStyle: .alert)
        
        let decline = UIAlertAction(title: NSLocalizedString("declineTitle",
                                                            comment: ""),
                                   style: .cancel) { _ in }
        
        let accept = UIAlertAction(title: NSLocalizedString("approveTitle",
                                                            comment: ""),
                                   style: .default) { _ in
                                    
                                    completion(true)
        }
        
        alertController.addAction(decline)
        alertController.addAction(accept)
        controller.present(alertController, animated: true, completion: nil)
        
    }
}
