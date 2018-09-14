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
            .getOneObject(for: transaction.corAccount!),
            let newCorAccount = accountDBManager
            .getOneObject(for: newCorAccount) else {
                assertionFailure()
                return false
        }
        
        let sum = transaction.sumTransaction
        
        oldCorAccount.sumAccount -= sum
        newCorAccount.sumAccount += newSum
        
        return true
        
    }
}
