import UIKit

/// Для отображения заметок транзакций в ячейках истории
class NoteViewController: UIViewController {
    
    let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextView()
    }
    
    private func addTextView() {
        self.view.addSubview(textView)

        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
