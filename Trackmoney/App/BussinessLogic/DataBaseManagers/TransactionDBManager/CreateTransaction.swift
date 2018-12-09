//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData

struct CreateTransaction {
    
    var context: NSManagedObjectContext
    var mManager: MessageManager
    var accountDBManager: AccountDBManager
    
    let date: NSDate
    let sum: Int32
    let mainAccount: Account
    let type: TransactionType
    var iconTransaction: String
    var category: String?
    var corAccount: Account?
    var note: String?
    
    init?(
        context: NSManagedObjectContext,
        mManager: MessageManager,
        message: [MessageKeyType: Any]
        ) {
        
        self.context = context
        self.mManager = mManager
        self.accountDBManager = AccountDBManager()
        
        self.date = NSDate(timeIntervalSinceNow: 0.0)
        self.sum = message[.sum] as! Int32
        self.iconTransaction = message[.icon] as! String
        
        guard let type = TransactionType(
            rawValue: message[.type] as! Int16) else {
                assertionFailure()
                return nil }
        
        let predicate = NSPredicate(format: "name = %@",
                                    message[.mainAccount] as! String)
        let result = accountDBManager.get(predicate)
        
        guard let object = result?.first else {
            assertionFailure()
            return nil }
        
        let accountMain = object as! Account
        self.type = type
        self.mainAccount = accountMain
        
        if mManager.isExistValue(for: .category, in: message) {
            self.category = message[.category] as? String
        }
        
        if mManager.isExistValue(for: .corAccount, in: message) {
            let predicate = NSPredicate(format: "name = %@",
                                        message[.corAccount] as! String)
            let result = accountDBManager.get(predicate)
            
            guard let object = result?.first else {
                assertionFailure()
                return nil }
            
            let accountCor = object as! Account
            self.corAccount = accountCor
        }
        
        if mManager.isExistValue(for: .note, in: message) {
            self.note = message[.note] as? String
        }
    }
    
    
    func execute() -> (DBEntity?, DBError?) {
        
        let transaction = Transaction(context: context)
        transaction.id = UUID().uuidString
        transaction.date = date
        transaction.sum = sum
        transaction.type = type.rawValue
        transaction.mainAccount = mainAccount.name
        transaction.icon = iconTransaction
        transaction.category = category
        transaction.corAccount = corAccount?.name
        transaction.note = note
        
        switch type {
        case .expense:
            accountDBManager.substract(for: mainAccount, sum: sum)
        case .income:
            accountDBManager.add(for: mainAccount, sum: sum)
        case .transfer:
            accountDBManager.move(
                fromAccount: mainAccount,
                toAccount: corAccount!, 
                sum: sum
            )
        }
        
        do {
            try context.save()
            return (transaction as DBEntity, nil)
        } catch {
            return (nil, DBError.contextDoNotBeSaved)
        }
    }
    
}
