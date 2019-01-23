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

    var dataProvider: ArchivesListDataProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        setBarButtons()
        dataProvider?.load()
    }

    private func setBarButtons() {
        
        rightBarButton = UIBarButtonItem(
            title: NSLocalizedString("deleteTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(deleteItem))
        rightBarButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func deleteItem() {
        var list = [String]()
        for (index, value) in isSelected.enumerated() {
            if value {
                list.append(archives[index])
            }
        }
        dataProvider?.delete(list)
    }
    
    private func addTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifire)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
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
    
}
