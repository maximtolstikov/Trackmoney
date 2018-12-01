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
        
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
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
                                 for: indexPath) as! LogCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! LogCell
        
        let date = transactions[indexPath.row].date as Date
        let stringFromDate = dateFormat.dateFormatter.string(from: date)
        cell.accountNameLable.text = transactions[indexPath.row].mainAccount
        cell.sumLable.text = String(transactions[indexPath.row].sum)
        cell.dateLable.text = stringFromDate
        
        // FIXME: - переделать на получение иконок из транзакции
        
        let type = transactions[indexPath.row].type
        switch type {
        case 0:
            cell.typeImage.image = UIImage(named: "Minus")
            cell.sumLable.textColor = #colorLiteral(red: 0.7835699556, green: 0.2945081919, blue: 0.07579417304, alpha: 1)
            cell.categoryNameLable.text = transactions[indexPath.row].category
        case 1:
            cell.typeImage.image = UIImage(named: "Plus")
            cell.sumLable.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell.categoryNameLable.text = transactions[indexPath.row].category
        case 2:
            cell.typeImage.image = UIImage(named: "Transfer")
            cell.sumLable.textColor = UIColor.darkGray
            let transaction = transactions[indexPath.row]
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
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("titleDeleteButton", comment: "")) { [weak self] (action, indexPath) in
                
                guard let id = self?.transactions[indexPath.row].id else { return }
                let result = self?.dataProvider?.delete(with: id)
                
                if result != nil, result == true {
                    self?.transactions.remove(at: indexPath.row)
                    tableView.reloadData()
                }
        }
        
        let edit = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("titleEditButton", comment: "")) { [weak self] (action, indexPath) in
                
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
