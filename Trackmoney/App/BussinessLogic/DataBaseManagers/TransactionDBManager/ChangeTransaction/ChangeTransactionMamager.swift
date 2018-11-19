// Для описания метода изменения транзакции

//swiftlint:disable force_cast

import CoreData

struct ChangeTransactionMamager {
    
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
    
    
    // Если все изменения успешны возвращает true
    func execute() -> Bool {
        
        for key in message.keys {
            
            // Пропускаем ключ idTransaction
            if key == .idTransaction {
                continue
            }
            
            if !chooseMethod(for: key) {
                return false
            }
            
        }
   
        return true
        
    }
    
    
    // Выбирает метод изменения по ключу
    private func chooseMethod(for key: MessageKeyType) -> Bool {
        
        if key == .sumTransaction {
            
            return ChangeSumTransaction.changeSum(
                newSum: message[key] as! Int32,
                transaction: transaction,
                accountDBManager: accountDBManager
            )
            
        } else if key == .corAccount {
            
            return ChangeCorAccountTransaction.changeCorAccount(
                newCorAccount: message[key] as! String,
                newSum: message[.sumTransaction] as! Int32,
                transaction: transaction,
                accountDBManager: accountDBManager
            )
            
        } else if key == .nameCategory {
            
            return ChangeCategoryTransaction.changeNameCategory(
                on: message[key] as! String,
                for: transaction
            )
            
        } else if key == .iconTransaction {
            
            return ChangeIconTransaction.changeIcon(
                on: message[key] as! String,
                for: transaction
            )
            
        } else {
            
            return true
            
        }
        
    }
    
}
