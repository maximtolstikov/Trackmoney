// Для описания методов по работе с BD у AccountViewController

//swiftlint:disable force_cast

import CoreData
import UIKit

class AccountDBManager: DBManager, DBManagerProtocol {

    
    func create(message: [MessageKeyType: Any]) -> Bool {
        
        let account = Account(context: context)
        account.nameAccount = message[.nameAccount] as! String
        account.sumAccount = message[.sumAccount] as! Int32

        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
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
    
    
    //Возвращает Account по имени
    func getOneObject(for name: String) -> Account? {
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameAccount = %@", name )
        
        do {
            let result = try context.fetch(fetchRequest)
            
            guard !result.isEmpty else {
                return nil
            }
            
            let account = result.first!   //swiftlint:disable:this force_unwrapping
            
            return account
            
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
    }

    
    func change(message: [MessageKeyType: Any]) -> Bool {
        
        guard let account = getOneObject(for: message[.nameAccount] as! String) else {
            assertionFailure()
            return false
        }
        
        if mManager.isExistValue(for: .newName, in: message) {
            account.nameAccount = message[.newName] as! String
            //TODO: сдесь нужен итератор по Транзакциям
        }
        if mManager.isExistValue(for: .iconAccount, in: message) {
            account.iconAccount = message[.iconAccount] as? String
        }
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    
    func delete(message: [MessageKeyType: Any]) -> Bool {
        
        guard let account = getOneObject(for: message[.nameAccount] as! String) else {
            assertionFailure()
            return false
        }
        
        //TODO: сдесь нужен итератор по Транзакциям в бэкграунде
        
        context.delete(account)
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
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
