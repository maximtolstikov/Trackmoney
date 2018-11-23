// Для описания метода изменнеия кореспондирующего счета Транзакции

//swiftlint:disable force_unwrapping

import CoreData

struct ChangeCorAccountTransaction {
    
    
    // Меняет счет получателя перевода
    static func changeCorAccount(
        newCorAccount: String,
        newSum: Int32,
        transaction: Transaction,
        accountDBManager: AccountDBManager
        ) -> Bool {
    
        guard let oldCorAccount = accountDBManager
            .getObjectByName(for: transaction.corAccount!),
            let newCorAccount = accountDBManager
            .getObjectByName(for: newCorAccount) else {
                assertionFailure()
                return false
        }
        
        let sum = transaction.sum
        
        oldCorAccount.sum -= sum
        newCorAccount.sum += newSum
        
        return true
        
    }
}
