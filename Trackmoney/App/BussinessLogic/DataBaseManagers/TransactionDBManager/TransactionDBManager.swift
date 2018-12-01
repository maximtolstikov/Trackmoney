//swiftlint:disable force_cast
import CoreData

class TransactionDBManager: DBManager, DBManagerProtocol {
    
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, ErrorMessage?) {
        
        guard let createTransaction = CreateTransaction(
            context: context,
            mManager: mManager,
            message: message
            ) else {
                assertionFailure()
                return (nil, ErrorMessage(error: .objectIsExistAlready))
        }
        
        return createTransaction.execute()
    }
    
    func get(_ predicate: NSPredicate) -> ([DBEntity]?, ErrorMessage?) {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try (context.fetch(fetchRequest), nil)
            
        } catch {
            print(error.localizedDescription)
            return (nil, ErrorMessage(error: .objectCanntGetFromBase))
        }
    }
    
    func update(_ message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let id = message[.id] else {
            return ErrorMessage(error: .messageHaventRequireValue)
        }
        
        let predicate = NSPredicate(format: "id = %@", id as! String)
        let result = get(predicate)
        
        guard let object = result.0?.first else {
            return ErrorMessage(error: .objectCanntGetFromBase)
        }
        
        let transaction = object as! Transaction
        
        let changeTransactionManager = ChangeTransactionManager(
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
    
    func delete(_ id: String) -> ErrorMessage? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate) as! ([Transaction]?, ErrorMessage?)
        
        if let error = result.1 {
            return error
        }
        
        guard let object = result.0?.first,
            let deleteTransaction = DeleteTransaction(
                context: context,
                transaction: object) else {
                    assertionFailure()
                    return ErrorMessage(error: .objectIsNotExist)
        }
        
        return deleteTransaction.execute() ? nil : ErrorMessage(error: .contextDoNotBeSaved)
    }
    
   
//    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
//
//        guard let createTransaction = CreateTransaction(
//            context: context,
//            mManager: mManager,
//            message: message
//            ) else {
//                assertionFailure()
//                return (nil, ErrorMessage(error: .transactionIsExist))
//        }
//
//        return createTransaction.execute()
//    }
//
//    func get(predicate: NSPredicate) -> ([NSManagedObject]?, ErrorMessage?) {
//
//        let fetchRequest: NSFetchRequest = Transaction.fetchRequest()
//        fetchRequest.predicate = predicate
//
//        do {
//            return try (context.fetch(fetchRequest), nil)
//
//        } catch {
//            print(error.localizedDescription)
//            return (nil, ErrorMessage(error: .transactionsCannotGet))
//        }
//    }
//
////    // Возвращает транзакцию по Id
////    func getObjectById(for id: NSManagedObjectID) -> Transaction? {
////
////        return context.object(with: id) as? Transaction
////    }
//
////    // Возвращает транзакцию по времени
////    func getObjectByDate(for date: NSDate) -> Transaction? {
////
////        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
////        fetchRequest.predicate = NSPredicate(
////            format: "date = %@", date)
////
////        do {
////            let result = try context.fetch(fetchRequest)
////
////            guard !result.isEmpty else {
////                return nil
////            }
////
////            let transaction = result.first!   //swiftlint:disable:this force_unwrapping
////
////            return transaction
////
////        } catch {
////            print(error.localizedDescription)
////
////            return nil
////        }
////    }
//
//    func update(message: [MessageKeyType: Any]) -> ErrorMessage? {
//
//        guard let transaction = getObjectById(
//            for: message[.idTransaction] as! NSManagedObjectID) else {
//            assertionFailure()
//            return ErrorMessage(error: .transactionIsNotExist)
//        }
//
//        let changeTransactionManager = ChangeTransactionMamager(
//            transaction: transaction,
//            message: message)
//
//        if changeTransactionManager.execute() {
//
//            do {
//                try context.save()
//                return nil
//            } catch {
//                print(error.localizedDescription)
//                return ErrorMessage(error: .contextDoNotBeSaved)
//            }
//        }
//
//        return ErrorMessage(error: .noName)
//    }
//
//    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
//
//        guard let transaction = getObjectById(
//            for: message[.idTransaction] as! NSManagedObjectID),
//            let deleteTransaction = DeleteTransaction(
//                context: context,
//                transaction: transaction) else {
//            assertionFailure()
//            return ErrorMessage(error: .transactionIsNotExist)
//        }
//
//        return deleteTransaction.execute() ? nil : ErrorMessage(error: .contextDoNotBeSaved)
//    }

}
