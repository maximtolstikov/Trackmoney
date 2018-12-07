import CoreData

/// Заполняет начальными данными
struct StartDataFill {
    
    lazy var accountDBManager = AccountDBManager()
    lazy var categoryDBManager = CategoryDBManager()
    lazy var transactionDBManager = TransactionDBManager()
    
    mutating func checkData() {
        
        let predicate = NSPredicate(value: true)
        let accountResult = accountDBManager.get(predicate)
        guard let accountArray = accountResult.0 else { return }
        
        if accountArray.isEmpty {
            
            let categoryResult = categoryDBManager.get(predicate)
            guard let categoryArray = categoryResult.0 else { return }
            
            if categoryArray.isEmpty {
                
                let transactionResult = transactionDBManager.get(predicate)
                guard let transactionArray = transactionResult.0 else { return }
                
                if transactionArray.isEmpty {
                    
                    fillData()
                }
            }
        }
    }
    
    private mutating func fillData() {
    
        let depositAccount: [MessageKeyType: Any] = [.name: "Deposit",
                                                  .icon: "icon",
                                                  .sum: Int32(500)]
        let debitAccount: [MessageKeyType: Any] = [.name: "Debit card",
                                                .icon: "icon",
                                                .sum: Int32(100)]
        let cashAccount: [MessageKeyType: Any] = [.name: "Cash",
                                                .icon: "icon",
                                                .sum: Int32(50)]
        
        _ = accountDBManager.create(depositAccount)
        _ = accountDBManager.create(debitAccount)
        _ = accountDBManager.create(cashAccount)
        
        let incomeCategory: [MessageKeyType: Any] = [.name: "💰 Income",
                                              .icon: "icon",
                                              .type: CategoryType.income.rawValue]
        let foodCategory: [MessageKeyType: Any] = [.name: "🍉 Food",
                                                .icon: "icon",
                                                .type: CategoryType.expense.rawValue]
        let carCategory: [MessageKeyType: Any] = [.name: "🚙 Car",
                                                .icon: "icon",
                                                .type: CategoryType.expense.rawValue]
        
        _ = categoryDBManager.create(incomeCategory)
        _ = categoryDBManager.create(foodCategory)
        _ = categoryDBManager.create(carCategory)
        
        let income: [MessageKeyType: Any] = [.sum: Int32(30),
                                             .mainAccount: "Cash",
                                             .icon: "icon",
                                             .type: TransactionType.income.rawValue,
                                             .category: "💰 Income",
                                             .note: ""]
        let firstEexpense: [MessageKeyType: Any] = [.sum: Int32(15),
                                             .mainAccount: "Debit card",
                                             .icon: "icon",
                                             .type: TransactionType.expense.rawValue,
                                             .category: "🚙 Car",
                                             .note: ""]
        let secondEexpense: [MessageKeyType: Any] = [.sum: Int32(15),
                                                    .mainAccount: "Cash",
                                                    .icon: "icon",
                                                    .type: TransactionType.expense.rawValue,
                                                    .category: "🍉 Food",
                                                    .note: ""]
        
        _ = transactionDBManager.create(income)
        _ = transactionDBManager.create(firstEexpense)
        _ = transactionDBManager.create(secondEexpense)
    }
    
}
