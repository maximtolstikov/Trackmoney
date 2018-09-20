// Для описания методов доступа к BD у LogViewController

//swiftlint:disable force_cast

import CoreData
import UIKit

class TransactionDBManager: DBManager, DBManagerProtocol {
    
    
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
        
        guard let transaction = CreateTransaction(
            context: context,
            mManager: mManager,
            message: message
            ) else {
                assertionFailure()
                return (nil, ErrorMessage(error: .transactionIsNotExist))
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
    
    
    func change(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let transaction = getOneObject(
            for: message[.dateTransaction] as! NSDate) else {
            assertionFailure()
            return ErrorMessage(error: .transactionIsNotExist)
        }
        
        let changeTransactionManager = ChangeTransactionMamager(
            transaction: transaction,
            message: message)
        
        if changeTransactionManager.execute() {
         
            do {
                try context.save()
                return nil
            } catch {
                print(error.localizedDescription)
                return ErrorMessage(error: .contextDoNotBeSaved)
            }
            
        }
        
        return ErrorMessage(error: .noName)
    }
    
    
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let transaction = getOneObject(
            for: message[.dateTransaction] as! NSDate),
            let deleteTransaction = DeleteTransaction(
                context: context,
                transaction: transaction) else {
            assertionFailure()
            return ErrorMessage(error: .transactionIsNotExist)
        }
        
        return deleteTransaction.execute() ? nil : ErrorMessage(error: .contextDoNotBeSaved)
        
    }

}
