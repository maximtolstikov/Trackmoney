//
//  LogUITableView.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 16/03/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class LogUITableView: UITableView {
    
    // MARK: - Public properties
    
    let controller: LogController
    
    // MARK: - Private properties
    
    var transactions = [Transaction]()
    
    // MARK: - Init
    
    init(frame: CGRect, controller: LogController) {
        self.controller = controller
        super.init(frame: frame, style: UITableView.Style.plain)
        delegate = self
        dataSource = self
        self.rowHeight = 60
        self.separatorStyle = .none
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.showsVerticalScrollIndicator = false
        register(LogCell.self, forCellReuseIdentifier: LogCell.reuseId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func set(transactions: [Transaction]) {
        self.transactions = transactions
        self.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension LogUITableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dequeueReusableCell(
            withIdentifier: LogCell.reuseId, for: indexPath) as? LogCell        
        cell?.configure(transaction: transactions[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate

extension LogUITableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LogCell,
              let note = transactions[indexPath.row].note,
              note != ""
        else { return }
        
        controller.showNote(on: cell, text: note)
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString(
                "deleteTitle", comment: "")) { [weak self] (action, indexPath) in
                
                guard let id = self?.transactions[indexPath.row].id else { return }
                self?.controller.dataProvider?.delete(with: id) { [weak self] flag in
                    if flag {
                        self?.transactions.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
        }
        
        let edit = UITableViewRowAction(
            style: .default,
            title: NSLocalizedString(
                "editTitle", comment: "")) { [weak self] (action, indexPath) in
                
                guard let transaction = self?.transactions[indexPath.row] else { return }
                self?.controller.edit(transaction: transaction)
        }
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension LogController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
