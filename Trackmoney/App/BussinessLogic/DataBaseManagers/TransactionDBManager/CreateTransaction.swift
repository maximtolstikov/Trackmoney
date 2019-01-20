//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData

struct CreateTransaction {
    
    var context: NSManagedObjectContext
    var mManager: MessageManager
    var accountDBManager: AccountDBManager
    let message: [MessageKeyType: Any]
    
    init(
        context: NSManagedObjectContext,
        mManager: MessageManager,
        message: [MessageKeyType: Any]
        ) {
        
        self.context = context
        self.mManager = mManager
        self.accountDBManager = AccountDBManager()
        self.message = message
    }
    
    
    func execute() -> (DBEntity?, DBError?) {
        
        let transaction = Transaction(context: context)
        transaction.id = UUID().uuidString
        transaction.date = setDate()
        let sum = message[.sum] as! Int32
        transaction.sum = sum
        transaction.icon = message[.icon] as! String
        transaction.note = message[.note] as? String
        transaction.category = setCategory()
        
        guard let type = TransactionType(
            rawValue: message[.type] as! Int16) else {
                assertionFailure()
                return (nil, DBError.messageHaventRequireValue) }
        transaction.type = type.rawValue
        
        guard let mainAccount = accountDBManager
            .get(predicate(by: message[.mainAccount] as! String))?
            .first as? Account else {
                return (nil, DBError.objectIsNotExist)
        }
        transaction.mainAccount = mainAccount.name
        
        var corAccount: Account? = nil
        if mManager.isExistValue(for: .corAccount, in: message) {
            guard let account = accountDBManager
                .get(predicate(by: message[.corAccount] as! String))?
                .first as? Account else {
                    return (nil, DBError.objectIsNotExist)
            }
            corAccount = account
            transaction.corAccount = corAccount?.name
        }
        
        switch type {
        case .expense:
            accountDBManager.substract(for: mainAccount, sum: sum)
        case .income:
            accountDBManager.add(for: mainAccount, sum: sum)
        case .transfer:
            accountDBManager.move(
                fromAccount: mainAccount,
                toAccount: corAccount!,
                sum: sum)
        }
        
        do {
            try context.save()
            return (transaction as DBEntity, nil)
        } catch {
            return (nil, DBError.contextDoNotBeSaved)
        }
    }
    
    // Устанавливает дату
    private func setDate() -> NSDate {
        let date = mManager
            .isExistValue(for: .date, in: message) ? nil : message[.date] as? String
        
        return DateSetter().date(stringDate: date)
    }
    
    // Проверяет существует ли Account
    private func isAccount(name: String) -> Bool {
        
        let predicate = NSPredicate(format: "name = %@", name)
        guard accountDBManager.get(predicate)?.first != nil else { return false }
        return true
    }
    
    // Устанавливает категорию
    private func setCategory() -> String? {
        if mManager.isExistValue(for: .category, in: message) {
            return message[.category] as? String
        }
        return nil
    }
    
    // Устанавливает corAccount
    private func setCorAccount() -> String? {
        if mManager.isExistValue(for: .corAccount, in: message) {
            let corAccountName = message[.corAccount] as! String
            guard isAccount(name: corAccountName) else { return nil }
            return corAccountName
        } else {
            return nil
        }
    }
    
    // Возвращает предикат по имени счета
    private func predicate(by name: String) -> NSPredicate {
        return NSPredicate(format: "name = %@", name)
    }
    
}
