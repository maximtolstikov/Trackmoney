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
                  .getOneObject(for: transaction.nameAccount),
              let type = TransactionType(rawValue: transaction.typeTransaction) else {
                assertionFailure()
                return false
        }
        
        let oldSum = mainAccount.sumAccount
        let difference = oldSum - newSum
        
        switch type {
        case .expense:
            mainAccount.sumAccount += difference
        case .income:
            mainAccount.sumAccount -= difference
        case .transfer:
            
            //swiftlint:disable force_unwrapping
            guard let corAccount = accountDBManager
                .getOneObject(for: transaction.corAccount!) else {
                    assertionFailure()
                    return false
            }
            
            mainAccount.sumAccount += difference
            corAccount.sumAccount -= difference
        }
        
        return true
        
    }
    
}
