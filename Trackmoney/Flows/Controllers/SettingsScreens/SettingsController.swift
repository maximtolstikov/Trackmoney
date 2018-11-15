// Для настройки контроллера Настроек

import UIKit

class SettingsController: UIViewController {
    
    var tableView = UITableView()
    let cellIndentifire = "myCell"
    var arrayPoint: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        addTable()
        
        let gester = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipes(_ :)))
        gester.direction = .down
        self.view.addGestureRecognizer(gester)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .down {
            dismissBack()
        }
    }
    
    // создаем кнопку назад
    private func setBackButton() {
        
        let leftBackButton = UIBarButtonItem(
            image: UIImage(named: "Arrow_down"),
            style: .done,
            target: self,
            action: #selector(dismissBack))
        
        self.navigationItem.leftBarButtonItem = leftBackButton
    }
    
    @objc func dismissBack() {
        dismiss(animated: true, completion: nil)
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


extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return arrayPoint.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = arrayPoint[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nameCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        print(arrayPoint[indexPath.row])
        
        switch nameCell {
        case SettingListType.getTitleFor(title: SettingListType.accountsSetting):
            let controller = AccountsSettingsControllerBilder().viewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case SettingListType.getTitleFor(title: SettingListType.categoriesSettings):
            let controller = CategorySettingsControllerBilder().viewController()
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
//        view.backgroundColor = UIColor.gray
//        
//        return viewHeader
//    }
    
}
