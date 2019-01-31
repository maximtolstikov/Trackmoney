import UIKit

class SettingsController: UIViewController {
    
    var tableView = UITableView()
    let cellIndentifire = "myCell"
    var categorySettings = [String]()
    var entitiesList = [String]()
    var archivesList = [String]()
    var dataProvider: SettingsControllerDataProvider?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarButtons()
        addTable()
        dataProvider?.loadData()
        setupSwipeDown()
    }
    
    func setupSwipeDown() {
        
        let gestre = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipes(_ :)))
        gestre.direction = .down
        self.view.addGestureRecognizer(gestre)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            dismissBack()
        }
    }
    
    private func setBarButtons() {
        
        let leftBackButton = UIBarButtonItem(
            image: UIImage(named: "Arrow_down"),
            style: .done,
            target: self,
            action: #selector(dismissBack))
        
        let rightButton = UIBarButtonItem(
            title: NSLocalizedString("cancelTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(closeController))
        
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func dismissBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeController() {
        let controller = MainTabBarControllerBuilder().viewController()
        present(controller, animated: true)
    }
    
    //настраиваем и добавляем контроллер таблицы
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
                let controller = AccountsSettingsControllerBuilder().viewController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = CategorySettingsControllerBuilder().viewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        } else if indexPath.section == 1 {
            let controller = ArchivesListControllerBuilder().viewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
