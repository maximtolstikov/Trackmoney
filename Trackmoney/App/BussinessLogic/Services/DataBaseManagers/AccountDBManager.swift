// Для описания методов по работе с BD у AccountViewController

//swiftlint:disable force_cast

import CoreData
import UIKit

class AccountDBManager: DBManager, DBManagerProtocol {

    
    func create(message: [MessageKeyType: Any]) -> Bool {
        
        let account = Account(context: context)
        account.nameAccount = message[.nameAccount] as! String
        account.sumAccount = message[.sumAccount] as! Int32
//        if mManager.isExistValue(for: .iconAccount, in: message) {
//            account.iconAccount = message[.iconAccount] as? String
//        }
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }

    }
    
    
    func getAllObject() -> [NSManagedObject]? {
        
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
    func getOneObject(message: [MessageKeyType: Any]) -> NSManagedObject? {
        
        guard let name = message[.nameAccount] else { return nil }
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameAccount = %@", name as! String)
        
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
        
        guard let result = getOneObject(message: message) else {
            //assertionFailure()
            return false
        }
        
        let account = result as! Account
        
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
        
        guard let account = getOneObject(message: message) else {
            //assertionFailure()
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
  
}
