// Для описания контроллера Счетов

//swiftlint:disable comma

import UIKit

class AccountsController: UIViewController {
    
    // максимальное колличество строк после которого включается scroll
    private let countMaxCell = 8
    
    var tableView = UITableView()
    let cellIndentifire = "myCell"
        var sortManager: CustomSortManager!
    
    // массив со счетами (устанавливается при вызове loadData() )
    var accounts: [Account]! {
        didSet {
            setHeightRow()
            accounts = sortManager.sortedArray(accounts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // проверяет новый ли тип статус бара
    var hasTopNotch: Bool {
        if #available (iOS 11.0,  *) {
            return UIApplication.shared.delegate?
                .window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    // поставщик данных
    var dataLoader: DataProviderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        addTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataLoader?.loadData()
        
        if accounts.count < countMaxCell {
            tableView.isScrollEnabled = false
        }
        
    }
    
    
    //настраиваем и добавляем контроллер таблицы
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountsCell.self, forCellReuseIdentifier: cellIndentifire)
        self.view.addSubview(tableView)
        
    }
    
    // настраивает высоту ячейки
    func setHeightRow() {
        
        guard accounts?.count != nil else { return }
        
        if accounts.count >= countMaxCell {
            tableView.rowHeight = CGFloat(80)
        } else {
            let toolBarHeight = navigationController?.toolbar.frame.height
            // на iphone 10 статусБар складывается из верхнего и нижнего
            let statusBarHeight = hasTopNotch ? CGFloat(78) : CGFloat(20)
            let navigationBarHeight = navigationController?.navigationBar.frame.height
            //swiftlint:disable next force_unwrapping
            let heightRow = (
                tableView.frame.size.height
                - (
                    toolBarHeight!
                    + statusBarHeight
                    + navigationBarHeight!
                  )
                ) / CGFloat(accounts.count)
            tableView.rowHeight = CGFloat(heightRow)
           
        }
    }
    
}

extension AccountsController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        guard accounts?.count != nil else { return 0 }
        return accounts.count
        
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //swiftlint:disable next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire,
                                                 for: indexPath) as! AccountsCell
        
        cell.accountNameLable.text = accounts[indexPath.row].name
        cell.sumLable.text = String(accounts[indexPath.row].sum)
        
        return cell
        
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        ChooseTransactionAlert().show(
            controller: self,
            nameAccount: accounts[indexPath.row].name)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
