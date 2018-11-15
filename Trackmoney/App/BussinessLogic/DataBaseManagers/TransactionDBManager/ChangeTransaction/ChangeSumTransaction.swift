// Для описания методов изменения суммы транзакции

import CoreData

struct ChangeSumTransaction {
    
    // Меняет сумму транзакции
    static func changeSum(
        newSum: Int32,
        transaction: Transaction,
        accountDBManager: AccountDBManager
        ) -> Bool {
        
        guard let mainAccount = accountDBManager
                  .getObjectByName(for: transaction.nameAccount),
              let type = TransactionType(rawValue: transaction
                .typeTransaction) else {
                assertionFailure()
                return false
        }
        
        let oldSum = transaction.sumTransaction
        let difference = newSum - oldSum
        
        switch type {
        case .expense:
            mainAccount.sumAccount -= difference
        case .income:
            mainAccount.sumAccount += difference
        case .transfer:
            
            //swiftlint:disable force_unwrapping
            guard let corAccount = accountDBManager
                .getObjectByName(for: transaction.corAccount!) else {
                    assertionFailure()
                    return false
            }
            
            mainAccount.sumAccount -= difference
            corAccount.sumAccount += difference
        }
        
        transaction.sumTransaction = newSum
        
        return true
        
    }
    
}
