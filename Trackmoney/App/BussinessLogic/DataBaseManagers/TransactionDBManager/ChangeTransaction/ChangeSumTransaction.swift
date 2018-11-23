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
                  .getObjectByName(for: transaction.mainAccount),
              let type = TransactionType(rawValue: transaction.type) else {
                assertionFailure()
                return false
        }
        
        let oldSum = transaction.sum
        let difference = newSum - oldSum
        
        switch type {
        case .expense:
            mainAccount.sum -= difference
        case .income:
            mainAccount.sum += difference
        case .transfer:
            
            //swiftlint:disable force_unwrapping
            guard let corAccount = accountDBManager
                .getObjectByName(for: transaction.corAccount!) else {
                    assertionFailure()
                    return false
            }
            
            mainAccount.sum -= difference
            corAccount.sum += difference
        }
        
        transaction.sum = newSum
        
        return true
        
    }
    
}
