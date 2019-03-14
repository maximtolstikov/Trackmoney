import UIKit

/// Нстроеки Категорий
class CategorySettingsController: UIViewController {

    // MARK: - Identifiers
    
    let cellIndentifire = "myCell"

    // MARK: - Dependency
    
    var incomeSortManager: CustomSortManager!
    var expenseSortManager: CustomSortManager!
    var dataProvider: DataProviderProtocol!

    // MARK: - Public properties
    
    var incomeCategories: [CategoryTransaction]! {
        didSet {
            incomeCategories = incomeSortManager.sortedArray(incomeCategories)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var expenseCategories: [CategoryTransaction]! {
        didSet {
            expenseCategories = expenseSortManager.sortedArray(expenseCategories)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Private properties
    
    private var tableView = UITableView()
    private var sortEditButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
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
    
    // MARK: - Configure controller
    
    // Устанавливает кнопки на NavigationBar
    private func setupBarButton() {
        let rightButton = UIBarButtonItem(
            title: NSLocalizedString("cancelTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(closeSettings))
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // Дабавляет ТableView
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    // Добавляет кнопки в Toolbar
    private func addBottomToolBar() {
        let addCategoryButtom = UIBarButtonItem(
            title: NSLocalizedString("addTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(addCategory))
        sortEditButton = UIBarButtonItem(
            title: NSLocalizedString("sortTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(sortDeleteCategory))
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let buttoms = [
            addCategoryButtom,
            flexSpace,
            sortEditButton]
        self.setToolbarItems(buttoms, animated: true)
    }
    
    // MARK: - Private methods
    
    // Вызывает контроллер формы категории
    @objc func addCategory() {
        ChooseTypeCategoryAlert().show(controller: self)        
    }
    
    // Включает режим редактирования списка
    @objc func sortDeleteCategory() {
        if self.tableView.isEditing {
            sortEditButton.title = NSLocalizedString("sortTitle", comment: "")
            self.tableView.setEditing(false, animated: true)
        } else {
            sortEditButton.title = NSLocalizedString("editTitle", comment: "")
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    @objc func closeSettings() {
        let controller = MainTabBarControllerBuilder().viewController()
        present(controller, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension CategorySettingsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard incomeCategories?.count != nil else { return 0 }
        if section == 0 {
            return incomeCategories.count
        } else {
            return expenseCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("incomeTitle", comment: "")
        } else {
            return NSLocalizedString("expenseTitle", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)
        
        let textInCell: String
        
        if indexPath.section == 0 {
            if let parentName = incomeCategories[indexPath.row].parent?.name {
                textInCell = "\(parentName)" + "/" + "\(incomeCategories[indexPath.row].name)"
            } else {
                textInCell = incomeCategories[indexPath.row].name
            }
        } else {
            if let parentName = expenseCategories[indexPath.row].parent?.name {
                textInCell = "\(parentName)" + "/" + "\(expenseCategories[indexPath.row].name)"
            } else {
                textInCell = expenseCategories[indexPath.row].name
            }
        }
        cell.textLabel?.text = textInCell
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}

// MARK: - UITableViewDelegate

extension CategorySettingsController: UITableViewDelegate {
    
    // Свайп по ячейке
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = configureDelete()
        let rename = configureRename()
        
        delete.backgroundColor = UIColor.red
        rename.backgroundColor = UIColor.blue
        
        return [delete, rename]
    }
    
    private func configureDelete() -> UITableViewRowAction {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("deleteTitle", comment: "")) { [weak self] (action, indexPath) in
                
                if indexPath.section == 0 {
                    
                    guard let item = self?.incomeCategories[indexPath.row] else {
                        assertionFailure()
                        return
                    }
                    
                    self?.dataProvider?.delete(with: item.id) { [weak self] flag in
                        
                        if flag {
                            self?.incomeSortManager.remove(
                                element: item,
                                in: self!.incomeCategories)
                            self?.incomeCategories.remove(at: indexPath.row)
                            self?.tableView.reloadData()
                        }
                    }
                } else {
                    guard let item = self?.expenseCategories[indexPath.row] else {
                        assertionFailure()
                        return
                    }
                    self?.dataProvider?.delete(with: item.id) { [weak self] flag in
                        if flag {
                            self?.expenseSortManager.remove(
                                element: item,
                                in: self!.expenseCategories)
                            self?.expenseCategories.remove(at: indexPath.row)
                            self?.tableView.reloadData()
                        }
                    }
                }
        }
        return delete
    }
    
    private func configureRename() -> UITableViewRowAction {
        
        let rename = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("renameTitle", comment: "")) { [weak self] (action, indexPath) in
                
                let category: CategoryTransaction?
                
                if indexPath.section == 0 {
                    category = self!.incomeCategories[indexPath.row]
                } else {
                    category = self!.expenseCategories[indexPath.row]
                }
                
                guard let item = category,
                    let type = CategoryType(rawValue: item.type) else {
                        assertionFailure()
                        return
                }
                
                let formController = CategoryFormControllerBuilder(typeCategory: type)
                    .viewController()
                formController.categotyForUpdate = item
                self?.present(formController, animated: true, completion: nil)
        }
        return rename
    }
    
    func tableView(_ tableView: UITableView,
                   canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    // Сортирует список
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath.section == 0 {
            
            guard destinationIndexPath.section == sourceIndexPath.section else { return }
            
            let item = incomeCategories[sourceIndexPath.row]
            incomeCategories.remove(at: sourceIndexPath.row)
            incomeCategories.insert(item, at: destinationIndexPath.row)
            incomeSortManager.swapElement(array: incomeCategories)
            tableView.reloadData()
            
        } else {
            
            guard destinationIndexPath.section == sourceIndexPath.section else { return }
            
            let item = expenseCategories[sourceIndexPath.row]
            expenseCategories.remove(at: sourceIndexPath.row)
            expenseCategories.insert(item, at: destinationIndexPath.row)
            expenseSortManager.swapElement(array: expenseCategories)
            tableView.reloadData()
        }
    }
    
}
