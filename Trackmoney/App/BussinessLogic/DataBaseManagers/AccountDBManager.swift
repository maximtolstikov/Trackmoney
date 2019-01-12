//swiftlint:disable force_cast
import CoreData
import UIKit

class AccountDBManager: DBManager, DBManagerProtocol {
    
    lazy var sortManager = CustomSortManager(.accounts)
    lazy var transactionDBManager = TransactionDBManager()
    
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, DBError?) {
        
        // Проверка что объекта с таким именем нет в базе
        guard let name = message[.name] else {
            return (nil, DBError.messageHaventRequireValue)
        }
        
        let predicateName = NSPredicate(format: "name = %@", name as! String)
        let response = get(predicateName)
        
        guard let resultByName = response, resultByName.isEmpty else {
            return (nil, DBError.objectIsExistAlready)
        }
        
        // Получение списока счетов до добавления для сортировки
        let predicatAll = NSPredicate(value: true)
        
        guard let resultForAll = get(predicatAll) else {
            return (nil, DBError.objectCanntGetFromBase)
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
            return (nil, DBError.contextDoNotBeSaved)
        }
    }
    
    func get(_ predicate: NSPredicate) -> [DBEntity]? {
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
            
        } catch {
            return nil
        }
    }
    
    func update(_ message: [MessageKeyType: Any]) -> DBError? {
        
        let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
        let result = get(predicate) as! [Account]?
        
        guard let account = result?.first else {
            return DBError.objectIsNotExist
        }
        
        if mManager.isExistValue(for: .name, in: message) {
            
            let newName = message[.name] as! String
            let predicate = NSPredicate(format: "mainAccount = %@", account.name)
            let result = transactionDBManager.get(predicate)
            
            guard let objects = result else {
                return DBError.objectCanntGetFromBase
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
            return DBError.contextDoNotBeSaved
        }
    }
    
    func delete(_ id: String) -> DBError? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate)
 
        guard let account = result?.first as? Account else {
            return DBError.objectIsNotExist
        }
        
        // Код проверял имеются ли транзакции сваязанные со счетом
        
//        let account = object as! Account
//        let transactionPredicate = NSPredicate(format: "mainAccount = %@", account.name)
//        let response = transactionDBManager.get(transactionPredicate)
//
//        if let objects = response, !objects.isEmpty {
//            var dates = [String]()
//            let transactions = objects as! [Transaction]
//            let dateFormat = DateFormat()
//
//            for transaction in transactions {
//                let date = transaction.date as Date
//                let string = dateFormat.dateFormatter.string(from: date)
//                dates.append(string)
//            }
//            return DBError.accountHaveTransaction(dates)
//        }
        context.delete(account)
        
        do {
            try context.save()
            return nil
        } catch {
            return DBError.contextDoNotBeSaved
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
