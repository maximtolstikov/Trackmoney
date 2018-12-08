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
        
        setBarButton()
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
    
    private func setBarButton() {
        
        let rightButton = UIBarButtonItem(
            title: NSLocalizedString("cancelButton", comment: ""),
            style: .done,
            target: self,
            action: #selector(closeController))
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func closeController() {
        
        let controller = MainTabBarControllerBuilder().viewController()
        present(controller, animated: true)
    }
    
    // Настраивает и добавляет контроллер таблицы
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    // Настраивает и добавляет тулБар снизу
    private func addBottomToolBar() {
        
        let addAccountButtom = UIBarButtonItem(
            title: NSLocalizedString("titleAdd", comment: ""),
            style: .done,
            target: self,
            action: #selector(addAccount))
        
        let deleteAccountButton = UIBarButtonItem(
            title: NSLocalizedString("titleSort", comment: ""),
            style: .done,
            target: self,
            action: #selector(sortDeleteAccount))
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let buttoms = [
            addAccountButtom,
            flexSpace,
            deleteAccountButton]
        
        self.setToolbarItems(buttoms, animated: true)
    }
    
    // Добавляет Счет
    @objc func addAccount() {
        
        let controller = AccountFormControllerBuilder().viewController()
        present(controller, animated: true, completion: nil)
    }
    
    // Включает режим редактирования списка
    @objc func sortDeleteAccount() {
        
        if self.tableView.isEditing {
            
            self.tableView.setEditing(false, animated: true)
        } else {
            
            self.tableView.setEditing(true, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // Свайп по ячейке
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("titleDeleteButton", comment: "")) { [weak self] (action, indexPath) in
                
                guard let item = self?.accounts[indexPath.row],
                    let array = self?.accounts else { return }
                
                let result = self?.dataProvider?.delete(with: item.id)
                
                if result != nil, result == true {
                    
                    self?.sortManager.remove(element: item, in: array)
                    self?.accounts.remove(at: indexPath.row)
                    
                    tableView.reloadData()
                }
        }
        
        let rename = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("titleRename", comment: "")) { [weak self] (action, indexPath) in
                
                let item = self!.accounts[indexPath.row]
                let controller = AccountFormControllerBuilder()
                    .viewController()
                controller.accountForUpdate = item
                
                self?.present(controller, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.red
        rename.backgroundColor = UIColor.blue
        
        return [delete, rename]
    }
    
    func tableView(_ tableView: UITableView,
                   canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return tableView.isEditing
    }
    
    // Сортирует список
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        
        let item = accounts[sourceIndexPath.row]
        accounts.remove(at: sourceIndexPath.row)
        accounts.insert(item, at: destinationIndexPath.row)
        
        sortManager.swapElement(array: accounts)
    }
    
}
