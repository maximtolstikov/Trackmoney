//swiftlint:disable force_cast
import CoreData
import UIKit

class AccountDBManager: DBManager, DBManagerProtocol {
    
    lazy var sortManager = CustomSortManager(entity: Account.self)
    lazy var transactionDBManager = TransactionDBManager()
    
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, ErrorMessage?) {
        
        // Проверка что объекта с таким именем нет в базе
        guard let name = message[.name] else {
            return (nil, ErrorMessage(error: .messageHaventRequireValue))
        }
        
        let predicateName = NSPredicate(format: "name = %@", name as! String)
        let resultForName = get(predicateName)
        
        guard resultForName.1 == nil else {
            return (nil, resultForName.1)
        }
        //swiftlint:disable next force_unwrapping
        guard (resultForName.0?.isEmpty)! else {
            return (nil, ErrorMessage(error: .objectIsExistAlready))
        }
        
        // Получение списока счетов до добавления для сортировки
        let predicatAll = NSPredicate(value: true)
        
        guard let resultForAll = get(predicatAll).0 else {
            return (nil, ErrorMessage(error: .objectCanntGetFromBase))
        }
        
        let accounts = resultForAll as! [Account]
        
        // Создание нового объекта
        let account = Account(context: context)
        
        account.id = UUID().uuidString
        account.name = message[.name] as! String
        account.sum = message[.sum] as! Int32
        account.icon = message[.icon] as! String
        
        do {
            try context.save()
            
            // Сортирует список с пользовательской последовательностью
            // и добавляет в конец новый элемент
            let sortedAccounts = sortManager.sortedArray(accounts)
            _ = sortManager.add(element: account, in: sortedAccounts)
            
            return (account, nil)
            
        } catch {
            return (nil, ErrorMessage(error: .contextDoNotBeSaved))
        }
    }
    
    func get(_ predicate: NSPredicate) -> ([DBEntity]?, ErrorMessage?) {
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return (result, nil)
            
        } catch {
            return (nil, ErrorMessage(error: .objectCanntGetFromBase))
        }
    }
    
    func update(_ message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
        let result = get(predicate) as! ([Account]?, ErrorMessage?)
        
        if let error = result.1 {
            return error
        }
        
        guard let account = result.0?.first else {
            return ErrorMessage(error: .objectIsNotExist)
        }
        
        if mManager.isExistValue(for: .name, in: message) {
            
            let newName = message[.name] as! String
            
            let predicate = NSPredicate(format: "mainAccount = %@", account.name)
            let result = transactionDBManager.get(predicate)
            
            guard let objects = result.0 else {
                    return ErrorMessage(error: .objectCanntGetFromBase)
            }
            
            let transactions = objects as! [Transaction]
            _ = transactions.map { $0.mainAccount = newName }
            
            account.name = newName
        }
        if mManager.isExistValue(for: .icon, in: message) {
            account.icon = message[.icon] as! String
        }
        
        do {
            try context.save()
            return nil
        } catch {
            return ErrorMessage(error: .contextDoNotBeSaved)
        }
    }
    
    func delete(_ id: String) -> ErrorMessage? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate) as! ([Account]?, ErrorMessage?)
        
        if let error = result.1 {
            return error
        }
        
        guard let account = result.0?.first else {
            return ErrorMessage(error: .objectIsNotExist)
        }
        
        context.delete(account)
        
        do {
            try context.save()
            return nil
        } catch {
            return ErrorMessage(error: .contextDoNotBeSaved)
        }
    }
    
    // Уменьшает сумму счета
    func substract(for account: Account, sum: Int32) {
        account.sum -= sum
    }    
    
    // Увеличивает сумму счета
    func add(for account: Account, sum: Int32) {
        account.sum += sum
    }
    
    // Переводит сумму с одного счета на другой
    func move(fromAccount: Account, toAccount: Account, sum: Int32) {
        fromAccount.sum -= sum
        toAccount.sum += sum
    }
    
}
