// Для описания методов по работе с BD у AccountViewController

//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping

import CoreData
import UIKit

class AccountDBManager: DBManager, DBManagerProtocol {
    
    lazy var sortManager = CustomSortManager(entity: Account.self)
    
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
        
        if getObjectByName(for: message[.nameAccount] as! String) != nil {
            return (nil, ErrorMessage(error: .accountIsExistAlready))
        }
        // Получает список счетов до добавления
        let accounts = get() as! [Account]
        
        let account = Account(context: context)
        account.name = message[.nameAccount] as! String
        account.sumAccount = message[.sumAccount] as! Int32
        
        do {
            try context.save()
            // Сортирует список с пользовательской последовательностью
            // и добавляет в конец новый элемент
            let sortedAccounts = sortManager.sortedArray(accounts)
            _ = sortManager.add(element: account, in: sortedAccounts)
            
            return (account.objectID, nil)
        } catch {
            print(error.localizedDescription)
            return (nil, ErrorMessage(error: .contextDoNotBeSaved))
        }

    }
    
    
    func get() -> [NSManagedObject]? {
        
        var resultRequest = [Account]()
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            resultRequest = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return resultRequest
        
    }
    
    
    //Возвращает Account по id
    func getObjectById(for id: NSManagedObjectID) -> Account? {

        return context.object(with: id) as? Account
        
    }
    
    
    // Возвращает Account по имени
    func getObjectByName(for name: String) -> Account? {
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name = %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            guard !result.isEmpty else {
                return nil
            }
            
            let account = result.first!
            return account
            
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
    }

    
    func change(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let account = getObjectById(
            for: message[.idAccount] as! NSManagedObjectID) else {
            assertionFailure()
            return ErrorMessage(error: .accountIsNotExist)
        }
        
        if mManager.isExistValue(for: .nameAccount, in: message) {
            account.name = message[.nameAccount] as! String
            //TODO: сдесь нужен итератор по Транзакциям
        }
        if mManager.isExistValue(for: .iconAccount, in: message) {
            account.iconAccount = message[.iconAccount] as? String
        }
        
        do {
            try context.save()
            return nil
        } catch {
            print(error.localizedDescription)
            return ErrorMessage(error: .contextDoNotBeSaved)
        }
        
    }
    
    
    // Удаляет аккаунт по id
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let account = getObjectById(
            for: message[.idAccount] as! NSManagedObjectID) else {
            assertionFailure()
            return ErrorMessage(error: .accountIsNotExist)
        }
        
        //TODO: сдесь нужен итератор по Транзакциям в бэкграунде
        
        context.delete(account)
        
        do {
            try context.save()
            return nil
        } catch {
            print(error.localizedDescription)
            return ErrorMessage(error: .contextDoNotBeSaved)
        }
        
    }
    
    // Уменьшает сумму счета
    func substract(for account: Account, sum: Int32) {
        account.sumAccount -= sum
    }
    
    
    // Увеличивает сумму счета
    func add(for account: Account, sum: Int32) {
        account.sumAccount += sum
    }
    
    
    // Переводит сумму с одного счета на другой
    func move(fromAccount: Account, toAccount: Account, sum: Int32) {
        fromAccount.sumAccount -= sum
        toAccount.sumAccount += sum
    }
  
}
