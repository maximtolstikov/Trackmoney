import UIKit

/// Alert для записи заметки в транзакции
struct NoteAlert {
    
    func show(controller: UIViewController,
              text: String,
              completion: @escaping (String) -> Void) {
        
        let ac = UIAlertController(title: NSLocalizedString("noteAlertTitle",
                                                            comment: ""),
                                   message: "",
                                   preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("titleCancelButton",
                                                            comment: ""),
                                   style: .cancel,
                                   handler: nil)
        let save = UIAlertAction(title: NSLocalizedString("titleSaveButton",
                                                          comment: ""),
                                 style: .cancel) { _ in
                                    guard let textField = ac.textFields?.first else { return }
                                    print(textField.text)
        }
        
        ac.addTextField { (textField) in
            textField.text = text
        }
        
        ac.addAction(cancel)
        ac.addAction(save)
        
       controller.present(ac, animated: true, completion: nil)
        
    }
}
