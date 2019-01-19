//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData

struct DeleteTransaction {
    
    var context: NSManagedObjectContext
    let transaction: Transaction
    
    init?(
        context: NSManagedObjectContext,
        transaction: Transaction
        ) {
        
        self.context = context
        self.transaction = transaction        
    }
    
    
    func execute(force: Bool) -> Bool {
        
        if !force {
            let accountDBManager = AccountDBManager()
            let predicate = NSPredicate(format: "name = %@", transaction.mainAccount)
            let result = accountDBManager.get(predicate) as! [Account]?
            
            guard let mainAccount = result?.first else {
                return false }
            
            guard let type = TransactionType(
                rawValue: transaction.type) else {
                    assertionFailure()
                    return false }
            
            let sum = transaction.sum
            
            switch type {
            case .expense:
                accountDBManager.add(for: mainAccount, sum: sum)
            case .income:
                accountDBManager.substract(for: mainAccount, sum: sum)
            case .transfer:
                let predicate = NSPredicate(format: "name = %@", transaction.corAccount!)
                let result = accountDBManager.get(predicate) as! [Account]?
                
                guard let corAccount = result?.first else {
                    assertionFailure()
                    return false }
                
                accountDBManager.move(fromAccount: corAccount,
                                      toAccount: mainAccount,
                                      sum: sum)
            }
        }        
        context.delete(transaction)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
}
