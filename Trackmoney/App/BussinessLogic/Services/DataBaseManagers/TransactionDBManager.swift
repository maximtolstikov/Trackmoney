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
    
    
    // Возвращает транзакцию по времяни
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
        
//        guard let result = getOneObject(message: message) else {
//            assertionFailure()
//            return false
//        }
//
//        let transaction = result as! Transaction
//
//        if mManager.isExistValue(for: .sum, in: message) {
//            transaction.sum = message[.sum] as! Int32
//
//        }
//        if mManager.isExistValue(for: .icon, in: message) {
//            account.icon = message[.icon] as? String
//        }
//
//        do {
//            try context.save()
//            return true
//        } catch {
//            print(error.localizedDescription)
            return false
//        }
        
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

    
    
//    //TODO: изменить получение порциями
//    // Возвращает все объекты транзакций
//    func getTransactions() -> [Transaction]? {
//
//        var resultRequest = [Transaction]()
//        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
//        do {
//            resultRequest = try context.fetch(fetchRequest)
//        } catch {
//            assertionFailure()
//            print(error.localizedDescription)
//        }
//        return resultRequest
//
//    }
//
//
//    // Удаляет транзакцию по дате
//    func deleteTransaction(on date: NSDate) {
//
////TODO: дописать метод удаления транзакции
//
//    }
//
//}



//func deleteTransaction(transactionDate: NSDate){
//    guard let transaction = getTransaction(date: transactionDate) else {return}
//    let sum = transaction.sum
//    let mainAccount = transaction.mainAccount
//    let corAccount = transaction.corAccount
//
//    switch transaction.type {
//    case 0:
//        mainAccount.sum += sum
//    case 1:
//        mainAccount.sum -= sum
//    case 2:
//        mainAccount.sum += sum
//        corAccount?.sum -= sum
//    default:
//        return
//    }
//
//    context.delete(transaction)
//    do{
//        try context.save()
//    } catch {
//        print(error.localizedDescription)
//    }
}
