import UIKit

/// Контроллер журнала
class LogController: UIViewController {
    
    // MARK: - Custom types
    
    var tableView: LogUITableView!
    
    // MARK: - Lazy properties
    
    lazy var popViewController: NoteViewController = {
        let controller = NoteViewController()
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: controller.view.bounds.width,
                                                 height: 60)
        return controller
    }()
    
    // MARK: - Dependency
    
    var dataProvider: DataProviderProtocol?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = LogUITableView(frame: view.bounds, controller: self)
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataProvider?.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popViewController.dismiss(animated: false)
    }
    
    // MARK: - Public methods
    
    public func edit(transaction: Transaction) {
        guard let type = TransactionType(rawValue: transaction.type) else { return }
        let controller = TransactionFormControllerBuilder()
            .viewController(transactionType: type)
        controller.topChooseButtonText = transaction.mainAccount
        controller.sumTextFieldText = String(transaction.sum)
        controller.transactionID = transaction.id
        controller.note = transaction.note
        if type == TransactionType.transfer {
            controller.bottomChooseButtonText = transaction.corAccount
        } else {
            controller.bottomChooseButtonText = transaction.category
        }
        present(controller, animated: true, completion: nil)
    }
    
    public func showNote(on: LogCell, text: String) {
        popViewController.noteText.text = text
        
        let popOver = popViewController.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = on.sumLable
        
        present(popViewController, animated: true)
    }
    
}
