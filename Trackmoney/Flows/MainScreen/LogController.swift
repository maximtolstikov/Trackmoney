//swiftlint:disable force_cast
import UIKit

/// Для описания контроллера журнала
class LogController: UIViewController {
    
    lazy var popViewController = NoteViewController()
    
    var tableView = UITableView()
    let cellIndentifire = "logCell"
    let dateFormat = DateFormat()
    
    var transactions: [Transaction]! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var dataProvider: DataProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataProvider?.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popViewController.dismiss(animated: false)
    }
    
    private func addTable() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(LogCell.self, forCellReuseIdentifier: cellIndentifire)
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)        
    }
    
}

extension LogController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard transactions?.count != nil else { return 0 }
        return transactions.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: cellIndentifire,
                                 for: indexPath)        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        let cell = cell as! LogCell
        let transaction = transactions[indexPath.row]
        
        let date = transaction.date as Date
        let stringFromDate = dateFormat.dateFormatter.string(from: date)
        cell.accountNameLable.text = transaction.mainAccount
        cell.sumLable.text = String(transaction.sum)
        cell.dateLable.text = stringFromDate
        cell.typeImage.image = UIImage(named: transaction.icon)
        
        let type = transaction.type
        switch type {
        case 0:
            cell.sumLable.textColor = #colorLiteral(red: 0.7835699556, green: 0.2945081919, blue: 0.07579417304, alpha: 1)
            cell.categoryNameLable.text = transaction.category
        case 1:
            cell.sumLable.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell.categoryNameLable.text = transaction.category
        case 2:
            cell.sumLable.textColor = UIColor.darkGray
            //swiftlint:disable next force_unwrapping
            cell.categoryNameLable.text = "\(transaction.mainAccount)"
                + "/" + "\(String(describing: transaction.corAccount!))"
        default:
            break
        }        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let note = transactions[indexPath.row].note,
            let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let sourceCell = cell as! LogCell
        
        popViewController.noteText.text = note
        popViewController.modalPresentationStyle = .popover
        
        let popOver = popViewController.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = sourceCell.sumLable
        
        popViewController
            .preferredContentSize = CGSize(width: self.view.bounds.width,
                                           height: 60)
        
        present(popViewController, animated: true)
        
    }
    
    //swiftlint:disable next closure_end_indentation
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("deleteTitle", comment: "")) { [weak self] (action, indexPath) in
                
            guard let id = self?.transactions[indexPath.row].id else { return }
                self?.dataProvider?.delete(with: id) { [weak self] flag in
                    if flag {
                        self?.transactions.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
           }
        
        let edit = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("editTitle", comment: "")) { [weak self] (action, indexPath) in
                
                guard let transaction = self?.transactions[indexPath.row],
                    let type = TransactionType(rawValue: transaction.type)  else { return }
                
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
                
                self?.present(controller, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
}

extension LogController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
    }
}
