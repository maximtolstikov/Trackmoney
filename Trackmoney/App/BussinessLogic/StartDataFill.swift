import CoreData

/// Заполняет начальными данными
struct StartDataFill {
    
    lazy var accountDBManager = AccountDBManager()
    lazy var categoryDBManager = CategoryDBManager()
    lazy var transactionDBManager = TransactionDBManager()
    
    mutating func checkData() {
        
        let predicate = NSPredicate(value: true)
        let accountResult = accountDBManager.get(predicate)
        guard let accountArray = accountResult else { return }
        
        if accountArray.isEmpty {
            
            let categoryResult = categoryDBManager.get(predicate)
            guard let categoryArray = categoryResult else { return }
            
            if categoryArray.isEmpty {
                
                let transactionResult = transactionDBManager.get(predicate)
                guard let transactionArray = transactionResult else { return }
                
                if transactionArray.isEmpty {
                    
                    fillData()
                }
            }
        }
    }
    
    private mutating func fillData() {
    
        addAccounts()
        addCategories()
        addTransactions()
    }
    
    private mutating func addAccounts() {
        
        let depositAccount: Message = [
            .name: "Deposit",
            .icon: "icon",
            .sum: Int32(500)]
        let debitAccount: Message = [
            .name: "Debit card",
            .icon: "icon",
            .sum: Int32(100)]
        let cashAccount: Message = [
            .name: "Cash",
            .icon: "icon",
            .sum: Int32(50)]
        
        _ = accountDBManager.create(depositAccount)
        _ = accountDBManager.create(debitAccount)
        _ = accountDBManager.create(cashAccount)
    }
    
    private mutating func addCategories() {
        
        let incomeCategory: Message = [
            .name: "💰 Income",
            .icon: "icon",
            .type: CategoryType.income.rawValue]
        let foodCategory: Message = [
            .name: "🍉 Food",
            .icon: "icon",
            .type: CategoryType.expense.rawValue]
        let carCategory: Message = [
            .name: "🚙 Car",
            .icon: "icon",
            .type: CategoryType.expense.rawValue]
        
        _ = categoryDBManager.create(incomeCategory)
        _ = categoryDBManager.create(foodCategory)
        _ = categoryDBManager.create(carCategory)
    }
    
    private mutating func addTransactions() {
        
        let income: Message = [
            .sum: Int32(30),
            .mainAccount: "Cash",
            .icon: "Plus",
            .type: TransactionType.income.rawValue,
            .category: "💰 Income",
            .note: "",
            .isRestore: false]
        let firstEexpense: Message = [
            .sum: Int32(15),
            .mainAccount: "Debit card",
            .icon: "Minus",
            .type: TransactionType.expense.rawValue,
            .category: "🚙 Car",
            .note: "",
            .isRestore: false]
        let secondEexpense: Message = [
            .sum: Int32(15),
            .mainAccount: "Cash",
            .icon: "Minus",
            .type: TransactionType.expense.rawValue,
            .category: "🍉 Food",
            .note: "",
            .isRestore: false]
        
        _ = transactionDBManager.create(income)
        _ = transactionDBManager.create(firstEexpense)
        _ = transactionDBManager.create(secondEexpense)
    }
    
}
