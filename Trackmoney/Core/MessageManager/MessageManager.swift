// Для вспомогательных функций сообщений между классами

struct MessageManager {
    
    let iconExpenseTransaction = ""
    let iconIncomeTransaction = ""
    let iconTransferTransaction = ""
    
    // создает сообщение для формы транзакции
    func craftTransactionMessage(transactionType: TransactionType,
                                 topButton: String,
                                 sum: Int32,
                                 bottomButton: String) -> [MessageKeyType: Any] {
        
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
    func craftCategoryFormMessage(nameCategory: String) -> [MessageKeyType: Any] {
        
        var dictionary = [MessageKeyType: Any]()
        dictionary[.nameCategory] = nameCategory
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
