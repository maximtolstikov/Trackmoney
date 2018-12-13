import UIKit

/// Alert для записи заметки в транзакции
class NoteAlert: AlertManager {
    
    func show(controller: UIViewController,
              text: String,
              completion: @escaping (String?) -> Void) {
        
        alertController = UIAlertController(title: NSLocalizedString("noteTitle",
                                                                     comment: ""),
                                            message: "",
                                            preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("cancelTitle",
                                                            comment: ""),
                                   style: .cancel) { _ in
                                    self.alertController = nil
        }
        let save = UIAlertAction(title: NSLocalizedString("okTitle",
                                                          comment: ""),
                                 style: .default) { _ in
                                    guard let textField = self.alertController.textFields?.first else { return }
                                    
                                    completion(textField.text)
                                    self.alertController = nil
        }
        
        alertController.addTextField { (textField) in
            textField.font = UIFont.systemFont(ofSize: 18.0)
            textField.textAlignment = .center
            textField.text = text
            textField.delegate = self.alertController
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
}

extension UIAlertController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        
        if (range.length + range.location) > currentCharacterCount {
            return false
        }
        
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 45
    }
}
