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
    
    var csvManager: CSVManager?
    var alert: NeedCancelAlert?

    // MARK: - Public properties
    
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    
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
            self.tableView.reloadData()
        }
    }

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        setupBarButtons()
        setToolbar()
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
    
    // MARK: - Private methods
    
    //swiftlint:disable for_where next
    @objc func deleteItem() {
        var list = [String]()
        for (index, value) in isSelected.enumerated() {
            if value {
                list.append(archives[index])
            }
        }
        csvManager?.deleteItems(list, completion: {
            self.loadData()
        })
    }
    
    //swiftlint:disable force_unwrapping
    // Создает архив даже если приложение свернуто
    @objc func createArchive() {
        guard let csvManager = self.csvManager else {
            alert?.show(
                controller: self,
                title: NSLocalizedString("unfortunateCreateArchiveTitile", comment: ""),
                body: nil)
            return }
        
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            
            self.backgroundTaskID = UIApplication.shared
                .beginBackgroundTask(withName: "Finish create archive tasks") {
                    UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                    self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                }
            DispatchQueue.main.async {
                csvManager.create { [weak self] (url) in
                    guard let name = url?.lastPathComponent else { return }
                    UserNotificationManager.shared
                        .addNotification(
                            title: NSLocalizedString("successfulCreateArchiveTitile", comment: ""),
                            body: name)
                    self?.archives.append(name)
                }
            }
            
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    private func loadData() {
        csvManager?.archivesList(completionHandler: { archives in
            guard let archives = archives else { return }
            self.archives = archives
        })
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
                
                self?.csvManager?.restorFrom(file: name, completionHandler: { (result) in
                    print(result)
                })
        }
        restore.backgroundColor = UIColor.green
        return [restore]
    }
    
}
