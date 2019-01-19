import CoreData

/// Создает сообщения для отправки в базу
struct MessageManager {
    
    let iconExpenseTransaction = "Minus"
    let iconIncomeTransaction = "Plus"
    let iconTransferTransaction = "Transfer"
    let iconAccount = "accountIcon"
    let iconCategory = "categoryIcon"
    
    // создает сообщение для формы транзакции
    //swiftlint:disable next function_parameter_count
    func craftTransactionMessage(transactionType: TransactionType,
                                 topButton: String,
                                 sum: Int32,
                                 bottomButton: String,
                                 note: String,
                                 id: String?) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.type] = transactionType.rawValue
        dictionary[.mainAccount] = topButton
        dictionary[.sum] = sum
 
        if id != nil {
            dictionary[.id] = id
        }
        if note != "" {
            dictionary[.note] = note
        }
        
        switch transactionType {
        case .expense:
            dictionary[.icon] = iconExpenseTransaction
            dictionary[.category] = bottomButton
        case .income:
            dictionary[.icon] = iconIncomeTransaction
            dictionary[.category] = bottomButton
        case .transfer:
            dictionary[.corAccount] = bottomButton
            dictionary[.icon] = iconTransferTransaction            
        }
        
        return dictionary
    }
    
    // Создает сообщение для счета
    func craftAccounеMessage(icon: String?,
                             nameAccount: String,
                             sumAccount: Int32,
                             id: String?) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.name] = nameAccount
        dictionary[.sum] = sumAccount
        if id != nil {
            dictionary[.id] = id
        }
        if icon != nil {
            dictionary[.icon] = icon
        } else {
            dictionary[.icon] = iconAccount
        }
        return dictionary        
    }
    
    // Создает сообщение для Категории
    func craftCategoryMessage(icon: String?,
                              nameCategory: String,
                              type: CategoryType,
                              parent: String?,
                              id: String?) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.name] = nameCategory
        dictionary[.type] = type.rawValue
        
        if parent != NSLocalizedString("chooseParentTitle", comment: "") {
            dictionary[.parent] = parent
        }
        if id != nil {
            dictionary[.id] = id
        }
        if icon != nil {
            dictionary[.icon] = icon
        } else {
            dictionary[.icon] = iconCategory
        }
        
        return dictionary
    }
    
    //Проверяет есть ли значение по ключу в словаре
    func isExistValue(
        for key: MessageKeyType,
        in dictionary: [MessageKeyType: Any]
        ) -> Bool {
        
        return (dictionary.index(forKey: key) != nil)
    }
    
}
