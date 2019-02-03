//swiftlint:disable force_cast
import CoreData

class TransactionDBManager: DBManager, DBManagerProtocol {
    
    
    func create(_ message: Message) -> (DBEntity?, DBError?) {
        
        let createTransaction = CreateTransaction(
            context: context,
            mManager: mManager,
            message: message)

        return createTransaction.execute()
    }
    
    
    func get(_ predicate: NSPredicate) -> [DBEntity]? {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
            
        } catch {
            return nil
        }
    }
    
    
    func update(_ message: Message) -> DBError? {
        
        guard let id = message[.id] else {
            return DBError.messageHaventRequireValue
        }
        
        let predicate = NSPredicate(format: "id = %@", id as! String)
        let result = get(predicate)
        
        guard let object = result?.first else {
            return DBError.objectCanntGetFromBase
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
                return DBError.contextDoNotBeSaved
            }
        }
        return DBError.noName
    }
    
    
    func delete(_ id: String, force: Bool) -> DBError? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate) as! [Transaction]?

        guard let object = result?.first,
            let deleteTransaction = DeleteTransaction(
                context: context,
                transaction: object) else {
                    assertionFailure()
                    return DBError.objectIsNotExist
        }
        return deleteTransaction.execute(force: force) ? nil : DBError.contextDoNotBeSaved
    }

}
