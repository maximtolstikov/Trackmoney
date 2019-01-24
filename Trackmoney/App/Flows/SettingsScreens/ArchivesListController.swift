//
//  ArchivesListController.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

/// Контроллер списка архивов
class ArchivesListController: UIViewController {
    
    var tableView = UITableView()
    var rightBarButton = UIBarButtonItem()
    let cellIndentifire = "myCell"
    var isSelected = [Bool]() {
        didSet {
            rightBarButton.isEnabled = isSelected.contains(true) ? true : false
        }
    }
    var archives = [String]() {
        didSet {
            isSelected = [Bool](repeating: false, count: archives.count)
            tableView.reloadData()
        }
    }
    var csvManager: CSVManager?
    
    // MARK: - Lifecycle controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        setBarButtons()
        loadData()
    }
    
    // MARK: - Configure controller

    private func setBarButtons() {
        
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    // MARK: - Button action
    
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
    
    // MARK: - Private methods
    
    private func loadData() {
        csvManager?.archivesList(completionHandler: { archives in
            guard let archives = archives else { return }
            self.archives = archives
        })
    }
    
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
                
                
//                self?.dataProvider?.delete(with: item.id) { [weak self] flag in
//                    
//                    if flag {
//                        self?.sortManager.remove(element: item, in: array)
//                        self?.accounts.remove(at: indexPath.row)
//                        tableView.reloadData()
//                    }
//                }
        }
        restore.backgroundColor = UIColor.red
        return [restore]
    }
    
}
