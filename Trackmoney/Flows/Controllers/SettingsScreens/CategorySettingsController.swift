//Для настройки контроллера Нстроек Категорий

import UIKit

class CategorySettingsController: UIViewController {
    
    var dataProvider: DataProviderProtocol!
    var tableView = UITableView()
    let cellIndentifire = "myCell"
    var categories: [CategoryTransaction]! {
        didSet {
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
        
        self.view.addSubview(tableView)
        
    }
    
    
    //настраиваем и добавляем тулБар снизу
    private func addBottomToolBar() {
        
        let addCategoryButtom = UIBarButtonItem(
            title: NSLocalizedString("titleAddCategory", comment: ""),
            style: .done,
            target: self,
            action: #selector(addAccount))
        
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
    
    
    //добавляет Счет
    @objc func addAccount() {
        
        let controller = CategoryFormControllerBilder().viewController()
        present(controller, animated: true, completion: nil)
        
    }
    
    
    // TODO: Сделать сортировку списка Категирий
    // удаляет сортирует Категории
    @objc func sortDeleteCategory() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    
}


extension CategorySettingsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        guard categories?.count != nil else { return 0 }
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].nameCategory
        return cell
    }
    
    
    //удаляет Категорию из списка
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard self.dataProvider.delete(
                with: self.categories[indexPath.row].objectID) else {
                    assertionFailure()
                    return
            }
            
            categories.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}