// Для описания метода изменения имени Категории у Транзакции

import CoreData

struct ChangeCategoryTransaction {
    
    
    // Меняем имя категории Транзакции
    static func changeNameCategory(
        on newNemeCategory: String,
        for transaction: Transaction
        ) -> Bool {
        
        transaction.category = newNemeCategory
        
        return true
        
    }
    
}
