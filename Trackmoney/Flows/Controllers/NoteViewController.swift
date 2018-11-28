import UIKit

/// Для отображения заметок транзакций в ячейках истории
class NoteViewController: UIViewController {
    
    let noteText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextView()
    }
    
    private func addTextView() {
        
        self.view.addSubview(noteText)

        noteText.adjustsFontSizeToFitWidth = true
        noteText.textAlignment = .center
        noteText.numberOfLines = 0
        
        noteText.widthAnchor.constraint(equalTo: view.widthAnchor,
                                        constant: -16).isActive = true
        noteText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
