// Для описания методов доступа к BD у LogViewController

//swiftlint:disable force_cast

import CoreData


class TransactionDBManager: DBManager, DBManagerProtocol {
    
    
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
        
        guard let createTransaction = CreateTransaction(
            context: context,
            mManager: mManager,
            message: message
            ) else {
                assertionFailure()
                return (nil, ErrorMessage(error: .transactionIsNotExist))
        }
        
        return createTransaction.execute()
        
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
    func getObjectById(for id: NSManagedObjectID) -> Transaction? {
        
        return context.object(with: id) as? Transaction
        
    }
    
    
    // Возвращает транзакцию по времени
    func getObjectByDate(for date: NSDate) -> Transaction? {
        
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
        
        guard let transaction = getObjectById(
            for: message[.idTransaction] as! NSManagedObjectID) else {
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
    
    
    // Удаляет транзакцию
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let transaction = getObjectById(
            for: message[.idTransaction] as! NSManagedObjectID),
            let deleteTransaction = DeleteTransaction(
                context: context,
                transaction: transaction) else {
            assertionFailure()
            return ErrorMessage(error: .transactionIsNotExist)
        }
        
        return deleteTransaction.execute() ? nil : ErrorMessage(error: .contextDoNotBeSaved)
        
    }

}
