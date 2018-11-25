import UIKit

/// Alert для записи заметки в транзакции
class NoteAlert: AlertManager {
    
    func show(controller: UIViewController,
              text: String,
              completion: @escaping (String?) -> Void) {
        
        alertController = UIAlertController(title: NSLocalizedString("noteAlertTitle",
                                                                     comment: ""),
                                            message: "",
                                            preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("titleCancelButton",
                                                            comment: ""),
                                   style: .cancel) {[weak self] _ in
                                    self?.alertController = nil
        }
        let save = UIAlertAction(title: NSLocalizedString("titleSaveButton",
                                                          comment: ""),
                                 style: .default) {[weak self] _ in
                                    guard let textField = self?.alertController.textFields?.first else { return }
                                    completion(textField.text)
                                    self?.alertController = nil
        }
        
        alertController.addTextField { (textField) in
            textField.text = text
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
}
