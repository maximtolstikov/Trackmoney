import UIKit

/// Описывает контроллер "Насторойки счетов"
class AccountsSettingsController: UIViewController {
    
    var dataProvider: DataProviderProtocol!
    var sortManager: CustomSortManager!
    var tableView = UITableView()
    let cellIndentifire = "myCell"
    var accounts: [Account]! {
        didSet {
            accounts = sortManager.sortedArray(accounts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTable()
        addBottomToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataProvider.loadData()
        self.navigationController?.isToolbarHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isToolbarHidden = true
    }
    
    
    @objc func tapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //настраиваем и добавляем контроллер таблицы
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        
        self.view.addSubview(tableView)
        
    }
    
    
    //настраиваем и добавляем тулБар снизу
    private func addBottomToolBar() {
        
        let addAccountButtom = UIBarButtonItem(
            title: NSLocalizedString("titleAddAccount", comment: ""),
            style: .done,
            target: self,
            action: #selector(addAccount))
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let buttoms = [flexSpace, addAccountButtom, flexSpace]
        
        self.setToolbarItems(buttoms, animated: true)
    }
    
    //добавляет Счет
    @objc func addAccount() {
        
        let controller = AccountFormControllerBilder().viewController()
        present(controller, animated: true, completion: nil)
    }

}

extension AccountsSettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        guard accounts?.count != nil else { return 0 }
        return accounts.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)
        
        
        cell.textLabel?.text = accounts[indexPath.row].name
        return cell
    }
    
    
    //удаляет счет из списка
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard self.dataProvider.delete(
                with: self.accounts[indexPath.row].objectID) else {
                    assertionFailure()
                    return
            }
            sortManager.remove(element: accounts[indexPath.row], in: accounts)
            accounts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   canMoveRowAt indexPath: IndexPath) -> Bool {

        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        
        let item = accounts[sourceIndexPath.row]
        accounts.remove(at: sourceIndexPath.row)
        accounts.insert(item, at: destinationIndexPath.row)
        
        sortManager.swapElement(array: accounts)
    }
    
}
