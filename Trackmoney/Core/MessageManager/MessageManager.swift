import CoreData

/// Создает сообщения для отправки в базу
struct MessageManager {
    
    let iconExpenseTransaction = ""
    let iconIncomeTransaction = ""
    let iconTransferTransaction = ""
    
    // создает сообщение для формы транзакции
    func craftTransactionMessage(transactionType: TransactionType,
                                 topButton: String,
                                 sum: Int32,
                                 bottomButton: String,
                                 id: NSManagedObjectID?) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.typeTransaction] = transactionType.rawValue
        dictionary[.nameAccount] = topButton
        dictionary[.sumTransaction] = sum
        dictionary[.iconTransaction] = iconExpenseTransaction
        if transactionType == TransactionType.transfer {
            dictionary[.corAccount] = bottomButton
        } else {
            dictionary[.nameCategory] = bottomButton
        }
        if id != nil {
            dictionary[.idTransaction] = id
        }
        return dictionary
    }
    
    //создает сообщение для формы аккаунта
    func craftAccountFormMessage(nameAccount: String,
                                 sumAccount: Int32) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.nameAccount] = nameAccount
        dictionary[.sumAccount] = sumAccount
        return dictionary        
    }
    
    //создает сообщение для формы счета
    func craftCategoryFormMessage(nameCategory: String, type: CategoryType) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.nameCategory] = nameCategory
        dictionary[.typeCategory] = type.rawValue
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
