//Для описания контроллера журнала

//swiftlint:disable force_cast

import UIKit

class LogController: UIViewController {
    
    var tableView = UITableView()
    let cellIndentifire = "logCell"
    
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
    
    //настраиваем и добавляем контроллер таблицы
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(LogCell.self, forCellReuseIdentifier: cellIndentifire)
        
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
        cell.accountNameLable.text = transactions[indexPath.row].nameAccount
        cell.accountNameLable.textColor = UIColor.red
        cell.sumLable.text = String(transactions[indexPath.row].sumTransaction)
        cell.categoryNameLable.text = transactions[indexPath.row].nameCategory
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("titleDeleteButton", comment: "")) { [weak self] (action, indexPath) in
                
                guard let id = self?.transactions[indexPath.row].objectID else { return }
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
                    let type = TransactionType(rawValue: transaction.typeTransaction)  else { return }
                
                let controller = TransactionFormControllerBilder()
                    .viewController(transactionType: type)

                controller.topChooseButtonText = transaction.nameAccount
                controller.sumTextFieldText = String(transaction.sumTransaction)
                controller.transactionID = transaction.objectID
                if type == TransactionType.transfer {
                    controller.bottomChooseButtonText = transaction.corAccount
                } else {
                    controller.bottomChooseButtonText = transaction.nameCategory
                }
                
                self?.present(controller, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    
}
