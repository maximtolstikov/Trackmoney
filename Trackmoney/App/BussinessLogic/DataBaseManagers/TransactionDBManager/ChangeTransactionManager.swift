//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData

struct ChangeTransactionManager {
    
    var accountDBManager: AccountDBManager
    var transaction: Transaction
    var message: [MessageKeyType: Any]
    
    init(
        transaction: Transaction,
        message: [MessageKeyType: Any]
        ) {
        
        self.accountDBManager = AccountDBManager()
        self.transaction = transaction
        self.message = message
    }
    
    func execute() -> Bool {
        
        guard let type = TransactionType(
            rawValue: transaction.type) else {
                assertionFailure()
                return false }

        if clearData(type: type) {
            
            if fillData(type: type) {
                
                return true
            }
        }
        return false
    }
    
    private func clearData(type: TransactionType) -> Bool {
        
        let mainPredicate = NSPredicate(format: "name = %@", transaction.mainAccount)
        let mainResult = accountDBManager.get(mainPredicate) as! ([Account]?, ErrorMessage?)
        
        guard let mainAccount = mainResult.0?.first else {
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
            let result = accountDBManager.get(predicate) as! ([Account]?, ErrorMessage?)
            
            guard let corAccount = result.0?.first else {
                assertionFailure()
                return false }
            
            accountDBManager.move(fromAccount: corAccount,
                                  toAccount: mainAccount,
                                  sum: sum)
        }
        return true
    }
    
    private func fillData(type: TransactionType) -> Bool {
        
        let mainAccountName = message[.mainAccount] as! String
        let mainPredicate = NSPredicate(format: "name = %@", mainAccountName)
        let mainResult = accountDBManager.get(mainPredicate) as! ([Account]?, ErrorMessage?)
        
        guard let mainAccount = mainResult.0?.first else {
            assertionFailure()
            return false }
        
        let sum = message[.sum] as! Int32
        
        transaction.sum = sum
        transaction.mainAccount = message[.mainAccount] as! String
        transaction.icon = message[.icon] as! String
        transaction.category = message[.category] as? String
        transaction.corAccount = message[.corAccount] as? String
        transaction.note = message[.note] as? String
        
        switch type {
        case .expense:
            accountDBManager.substract(for: mainAccount, sum: sum)
        case .income:
            accountDBManager.add(for: mainAccount, sum: sum)
        case .transfer:
            
            let predicate = NSPredicate(format: "name = %@", transaction.corAccount!)
            let result = accountDBManager.get(predicate) as! ([Account]?, ErrorMessage?)
            
            guard let corAccount = result.0?.first else {
                assertionFailure()
                return false }
            
            accountDBManager.move(
                fromAccount: mainAccount,
                toAccount: corAccount,
                sum: sum
            )
        }
        return true
    }
    
}
