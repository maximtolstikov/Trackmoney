// Для описания удаления Транзакции

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
    
    
    func execute() -> Bool {
        
        let accountDBManager = AccountDBManager()
        
        guard let mainAccount = accountDBManager.getOneObject(
            for: transaction.nameAccount),
            let type = TransactionType(
                rawValue: transaction.typeTransaction) else {
                    assertionFailure()
                    return false }
        
        let sum = transaction.sumTransaction
        
        switch type {
        case .expense:
            accountDBManager.add(for: mainAccount, sum: sum)
        case .income:
            accountDBManager.substract(for: mainAccount, sum: sum)
        case .transfer:
            guard let corAccount = accountDBManager.getOneObject(for: transaction.corAccount!) else { return false }
            accountDBManager.move(fromAccount: mainAccount, toAccount: corAccount, sum: sum)
        }
        
        context.delete(transaction)
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
}
