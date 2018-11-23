// Для описания метода изменения иконки Транзакции

import CoreData

struct ChangeIconTransaction {
    
    
    // Меняет иконку Транзакции
    static func changeIcon(
        on newIcon: String,
        for transaction: Transaction
        ) -> Bool {
        
        transaction.icon = newIcon
    
        return true
        
    }
    
}
