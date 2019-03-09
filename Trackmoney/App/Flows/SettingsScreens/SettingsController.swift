import UIKit

class SettingsController: UIViewController {

    // MARK: - Identifiers
    
    let cellIndentifire = "myCell"
    
    // MARK: - Constants
    
    var tableView = UITableView()
    var categorySettings = [String]()
    var entitiesList = [String]()
    var archivesList = [String]()
    
    // MARK: - Dependency
    
    var dataProvider: SettingsControllerDataProvider?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtons()
        addTable()
        dataProvider?.loadData()
        setupSwipeDownGesture()
    }
    
    // MARK: - Configure controller
    
    // Добавляет жест свайп вниз для закрытия
    private func setupSwipeDownGesture() {
        
        let gesture = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipes(_ :)))
        gesture.direction = .down
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            dismissBack()
        }
    }
    
    // Устанавливает кнопки на NavigationBar
    private func setupBarButtons() {
        
        let leftBackButton = UIBarButtonItem(
            image: UIImage(named: "Arrow_down"),
            style: .done,
            target: self,
            action: #selector(dismissBack))
        
        let rightButton = UIBarButtonItem(
            title: NSLocalizedString("cancelTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(closeSettings))
        
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // Добавляет TableView
    private func addTable() {
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIndentifire)
        tableView.isScrollEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    // MARK: - Navigation
    
    @objc func dismissBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeSettings() {
        let controller = MainTabBarControllerBuilder().viewController()
        present(controller, animated: true)
    }
    
    private func presentAccountsSettings() {
        let controller = AccountsSettingsControllerBuilder().viewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func presentCategoriesSettings() {
        let controller = CategoriesSettingsControllerBuilder().viewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func presentArchivesSettings() {
        let controller = ArchivesListControllerBuilder().viewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorySettings.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return entitiesList.count
        case 1:
            return archivesList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = entitiesList[indexPath.row]
        case 1:
            cell.textLabel?.text = archivesList[indexPath.row]
        default:
            break
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension SettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                presentAccountsSettings()
            } else {
                presentCategoriesSettings()
            }
        } else if indexPath.section == 1 {
            presentArchivesSettings()
        }
    }
    
}
