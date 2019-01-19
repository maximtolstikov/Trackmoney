//
//  CreaterArchive.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 19/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

/// Создает строки из сущьностей
struct CreaterStringsFromEntity {
    
    let accountDBManager: AccountDBManager
    let categoryDBManager: CategoryDBManager
    let transactionDBManager: TransactionDBManager
    
    init() {
        accountDBManager = AccountDBManager()
        categoryDBManager = CategoryDBManager()
        transactionDBManager = TransactionDBManager()
    }
    
    func string() -> String? {
        
        let predicate = NSPredicate(value: true)
        guard let accounts = accountDBManager.get(predicate) as? [Account],
            let categories = categoryDBManager.get(predicate) as? [CategoryTransaction],
            let tratsactions = transactionDBManager.get(predicate) as? [Transaction] else { return nil }
        
        var csvString: String = ""
        csvString.append(stringFrom(accounts: accounts))
        csvString.append(";")
        csvString.append(stringFrom(categoryies: categories))
        csvString.append(";")
        csvString.append(stringFrom(transactions: tratsactions))
        
        return csvString
    }
    
    private func stringFrom(accounts: [Account]) -> String {
        var string = ""
        for account in accounts {
            string.append("\(account.icon),\(account.name),\(String(describing: account.sum))\n")
        }
        return String(string.dropLast())
    }
    
    
    private func stringFrom(categoryies: [CategoryTransaction]) -> String {
        var string = ""
        for category in categoryies {
            string.append("\(category.icon),\(category.name),\(category.type),\(category.parent?.name ?? "nil")\n")
        }
        return String(string.dropLast())
    }
    
    // swiftlint:disable line_length
    private func stringFrom(transactions: [Transaction]) -> String {
        let formater = DateFormat().dateFormatter
        var string = ""
        for transaction in transactions {
            let date = transaction.date
            let stringDate = formater.string(from: date as Date)
            string.append("\(transaction.category ?? "nil"),\(transaction.corAccount ?? "nil"),\(stringDate),\(transaction.icon),\(transaction.mainAccount),\(transaction.note ?? "nil"),\(String(describing: transaction.sum)),\(String(describing: transaction.type))\n")
        }
        return String(string.dropLast())
    }
}
