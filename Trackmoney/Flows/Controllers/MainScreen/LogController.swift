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
    var dataLoader: DataProviderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        addTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataLoader?.loadData()
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
    

}
