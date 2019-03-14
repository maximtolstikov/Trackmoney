//
//  ArchivesListController.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

/// Контроллер управления архивами. Здесь можно создать, удалить и восстановить архив.
class ArchivesListController: UIViewController {

    // MARK: - Identifiers
    
    let cellIndentifire = "myCell"
    
    // MARK: - Dependency
    
    var archiveManager: ArchivesManager?
    
    // MARK: - Private properties
    
    private var tableView = UITableView()
    private var rightBarButton = UIBarButtonItem()
    private var isSelected = [Bool]() {
        didSet {
            rightBarButton.isEnabled = isSelected.contains(true) ? true : false
        }
    }
    private var archives = [String]() {
        didSet {
            isSelected = [Bool](repeating: false, count: archives.count)
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.tableView.reloadData()
        }
    }
    private var activityIndicator = UIActivityIndicatorView()

    // MARK: - ViewController lifecycle
    
    // TODO: - Сделать проверку на доступность iCloud
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        setupBarButtons()
        setToolbar()
        addActivityIndicator()
        loadData()
    }
    
    // Показываем и прячем тулбар
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Configure controller

    private func setupBarButtons() {
        rightBarButton = UIBarButtonItem(
            title: NSLocalizedString("deleteTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(deleteItem))
        rightBarButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func addTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    private func setToolbar() {
        let create = UIBarButtonItem(
            title: NSLocalizedString("createTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(createArchive))
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let buttons = [
            flexSpace,
            create,
            flexSpace]
        self.setToolbarItems(buttons, animated: true)
    }
    
    private func addActivityIndicator() {
        activityIndicator.style = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // MARK: - Private methods
    
    //swiftlint:disable for_where next
    // Удаляет выделенные в списке архивы
    @objc private func deleteItem() {
        var list = [String]()
        for (index, value) in isSelected.enumerated() {
            if value {
                list.append(archives[index])
            }
        }
        
        archiveManager?.deleteList(archives: list, completion: {
            self.loadData()
        })
    }
    
    
    // Создает архив даже если приложение свернуто
    @objc private func createArchive() {
        
        let expectationController = ExpectationViewController(type: .archiving)
        
        present(expectationController, animated: true) {
            self.archiveManager?.create(completion: { [weak self] (name) in
                DispatchQueue.main.async {
                    self?.archives.append(name)
                }
                sleep(3)
                expectationController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    // Обновляет данные при появлении контроллера
    private func loadData() {
        
        archiveManager?.archivesList(completion: { [weak self] list in
            guard let listName = list else { return }
            DispatchQueue.main.async {
                self?.archives = []
                self?.archives = listName
            }
        })
    }
    
    // Восстанавливает базу из архива
    private func restoreBy(name: String) {
        
        let expectationController = ExpectationViewController(type: .restoring)
        
        present(expectationController, animated: true) {
            self.archiveManager?.restore(name: name, completion: { (result) in
                sleep(3)
                expectationController.dismiss(animated: true, completion: nil)
                print(result)
            })
        }
    }
    
    // MARK: - Navigation
    
}

// MARK: - UITableViewDataSource

extension ArchivesListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return archives.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "myCell",
            for: indexPath)

        cell.textLabel?.text = archives[indexPath.row]
        cell.accessoryType = isSelected[indexPath.row] ? .checkmark : .none
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ArchivesListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        isSelected[indexPath.row] = !isSelected[indexPath.row]
        cell?.accessoryType = isSelected[indexPath.row] ? .checkmark : .none
    }
    
    // Свайп по ячейке
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let restore = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString("restoreBaseTitile", comment: "")) { [weak self] (action, indexPath) in
                
                let cell = tableView.cellForRow(at: indexPath)
                guard let name = cell?.textLabel?.text else { return }
                self?.restoreBy(name: name)
        }
        restore.backgroundColor = UIColor.green
        return [restore]
    }
    
}
