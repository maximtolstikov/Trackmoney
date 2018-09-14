// Для описания методов доступа к BD у LogViewController

//swiftlint:disable force_cast

import CoreData
import UIKit

class TransactionDBManager: DBManager, DBManagerProtocol {
    
    
    func create(message: [MessageKeyType: Any]) -> Bool {
        
        guard let transaction = CreateTransaction(
            context: context,
            mManager: mManager,
            message: message
            ) else {
                assertionFailure()
                return false
        }
        
        return transaction.execute()
        
    }
    
    
    //TODO: переделать на получение по порциям
    func get() -> [NSManagedObject]? {
        
        var resultRequest = [Transaction]()
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            resultRequest = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return resultRequest
        
    }
    
    
    // Возвращает транзакцию по времени
    func getOneObject(for date: NSDate) -> Transaction? {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "dateTransaction = %@", date)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            guard !result.isEmpty else {
                return nil
            }
            
            let transaction = result.first!   //swiftlint:disable:this force_unwrapping
            
            return transaction
            
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
    }
    
    
    func change(message: [MessageKeyType: Any]) -> Bool {
        
        guard let transaction = getOneObject(
            for: message[.dateTransaction] as! NSDate) else {
            assertionFailure()
            return false
        }
        
        let changeTransactionManager = ChangeTransactionMamager(
            transaction: transaction,
            message: message)
        
        if changeTransactionManager.execute() {
         
            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
            
        }
        
        return false
        
    }
    
    
    func delete(message: [MessageKeyType: Any]) -> Bool {
        
        guard let transaction = getOneObject(
            for: message[.dateTransaction] as! NSDate),
            let deletTransaction = DeleteTransaction(
                context: context,
                transaction: transaction) else {
            assertionFailure()
            return false
        }
        
        return deletTransaction.execute()
        
    }

}
