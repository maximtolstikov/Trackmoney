//swiftlint:disable force_unwrapping
//  CreaterEntitysFromFile.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 19/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

struct CreaterEntitysFromString {
    
    let messageManager: MessageManager
    let accountDBManager: AccountDBManager
    let categoryDBManager: CategoryDBManager
    let transactionDBManager: TransactionDBManager
    
    init() {
        messageManager = MessageManager()
        accountDBManager = AccountDBManager()
        categoryDBManager = CategoryDBManager()
        transactionDBManager = TransactionDBManager()
    }
    
    func restore(from: String) {
        
        cleanDataBase()
        
        let array = from.components(separatedBy: ";")
        guard array.count == 3 else { return }
        
        let stringsAccounts = array[0].components(separatedBy: "\n")
        let stringsCategories = array[1].components(separatedBy: "\n")
        let stringsTransactions = array[2].components(separatedBy: "\n")
        
        guard createAccounts(stringsAccounts),
            createCategories(stringsCategories),
            createTransactions(stringsTransactions) else {
                assertionFailure()
                return
        }
    }
    
    // MARK: - Отчищает базу перед востановлением
    
    func cleanDataBase() {
        let predicate = NSPredicate(value: true)
        let accountDBManager = AccountDBManager()
        let categoryDBManager = CategoryDBManager()
        let transactionDBManager = TransactionDBManager()
        
        guard let accounts = accountDBManager.get(predicate) as? [Account],
            let categories = categoryDBManager.get(predicate) as? [CategoryTransaction],
            let tratsactions = transactionDBManager.get(predicate) as? [Transaction] else { return }
        
        for transaction in tratsactions {
            _ = transactionDBManager.delete(transaction.id, force: true)
        }
        for category in categories {
            _ = categoryDBManager.delete(category.id, force: true)
        }
        for account in accounts {
            _ = accountDBManager.delete(account.id, force: true)
        }
    }
    
    // MARK: - Создаем сущьности из csv
    
    private func createAccounts(_ array: [String]) -> Bool {
        for string in array {
            let components = string.components(separatedBy: ",")
            guard !components.isEmpty,
                let sum = Int32(components[2]) else { return false }
            let message = messageManager
                .craftAccounеMessage(icon: components[0],
                                      nameAccount: components[1],
                                      sumAccount: sum,
                                      id: nil)
            let result = accountDBManager.create(message)
            if result.0 == nil {
                return false
            }
        }
        return true
    }
    
    
    private func createCategories(_ array: [String]) -> Bool {
        if array.first == "" {
            return true
        }
        
        for string in array {
            let components = string.components(separatedBy: ",")
            var parent: String? {
                return components[3] == "nil" ? nil : components[3]
            }
            
            guard let type = CategoryType(rawValue: components[2]) else { return false }
            
            let message = messageManager.craftCategoryMessage(
                icon: components[0],
                nameCategory: components[1],
                type: type,
                parent: parent,
                id: nil)
            let result = categoryDBManager.create(message)
            if result.0 == nil {
                return false
            }
        }
        return true
    }
    
    private func createTransactions(_ array: [String]) -> Bool {
        let formater = DateFormat().dateFormatter
        if array.first == "" {
            return true
        }
        
        for string in array {
            let companents = string.components(separatedBy: ",")
            var category: String? {
                return companents[0] == "nil" ? nil : companents[0]
            }
            var corAccount: String? {
                return companents[1] == "nil" ? nil : companents[1]
            }

            guard let number = Int16(companents[7]),
                let type = TransactionType(rawValue: number),
                let sum = Int32(companents[6]) else { return false }

            let message = messageManager.craftTransactionMessage(
                transactionType: type,
                topButton: companents[4],
                sum: sum,
                bottomButton: category ?? corAccount!,
                note: companents[5],
                id: nil,
                date: companents[2],
                isRestore: true)

            let result = transactionDBManager.create(message)
            if result.0 == nil {
                assertionFailure()
                return false
            }
        }
        return true
    }

}
