import UIKit

/// Класс контроллера Нстроек Категорий
class CategorySettingsController: UIViewController {
    
    var dataProvider: DataProviderProtocol!
    var sortManager: CustomSortManager!
    var tableView = UITableView()
    let cellIndentifire = "myCell"
    var incomeCategories: [CategoryTransaction]!
    var expenseCategories: [CategoryTransaction]! {
        didSet {
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
    
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    private func addBottomToolBar() {
        
        let addCategoryButtom = UIBarButtonItem(
            title: NSLocalizedString("titleAddCategory", comment: ""),
            style: .done,
            target: self,
            action: #selector(addCategory))
        
        let editCategoryButton = UIBarButtonItem(
            title: NSLocalizedString("titleSortDelete", comment: ""),
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
            editCategoryButton]
        
        self.setToolbarItems(buttoms, animated: true)
    }
    
    // Добавляет Категорию
    @objc func addCategory() {
        ChooseTypeCategoryAlert().show(controller: self)        
    }
    
    // Включает режим редактирования списка
    @objc func sortDeleteCategory() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    
}

extension CategorySettingsController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    // Удаляет Категорию из списка
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                guard self.dataProvider.delete(
                    with: self.incomeCategories[indexPath.row].id) else {
                        assertionFailure()
                        return
                }
                incomeCategories.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                guard self.dataProvider.delete(
                    with: self.expenseCategories[indexPath.row].id) else {
                        assertionFailure()
                        return
                }
                expenseCategories.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return tableView.isEditing
    }
    
//    func tableView(_ tableView: UITableView,
//                   moveRowAt sourceIndexPath: IndexPath,
//                   to destinationIndexPath: IndexPath) {
//
//        let item = categories[sourceIndexPath.row]
//        categories.remove(at: sourceIndexPath.row)
//        categories.insert(item, at: destinationIndexPath.row)
//
//        sortManager.swapElement(array: categories)
//    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            RenameEntity().show(controller: self,
                                entyty: incomeCategories[indexPath.row])
        } else {
            RenameEntity().show(controller: self,
                                entyty: expenseCategories[indexPath.row])
        }
        
    }
    
}
