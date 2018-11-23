// Для описания процесса создания Транзакции

//swiftlint:disable force_cast

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
    
    init?(
        context: NSManagedObjectContext,
        mManager: MessageManager,
        message: [MessageKeyType: Any]
        ) {
        
        self.context = context
        self.mManager = mManager
        self.accountDBManager = AccountDBManager()
        
        self.date = NSDate(timeIntervalSinceNow: 0.0)
        self.sum = message[.sumTransaction] as! Int32
        self.iconTransaction = message[.iconTransaction] as! String
        
        guard let type = TransactionType(
            rawValue: message[.typeTransaction] as! Int16) else {
                assertionFailure()
                return nil }
        guard let accountMain = accountDBManager.getObjectByName(
            for: message[.nameAccount] as! String) else {
                assertionFailure()
                return nil }
        
        self.type = type
        self.mainAccount = accountMain
        
        if mManager.isExistValue(for: .nameCategory, in: message) {
            self.category = message[.nameCategory] as? String
        }
        if mManager.isExistValue(for: .corAccount, in: message) {
            guard let accountCor = accountDBManager.getObjectByName(
                for: message[.corAccount] as! String) else {
                    assertionFailure()
                    return nil }
            self.corAccount = accountCor
        }
        
    }
    
    
    func execute() -> (NSManagedObjectID?, ErrorMessage?) {
        
        let transaction = Transaction(context: context)
        transaction.date = date
        transaction.sum = sum
        transaction.type = type.rawValue
        transaction.mainAccount = mainAccount.name
        transaction.icon = iconTransaction
        transaction.category = category
        transaction.corAccount = corAccount?.name
        
        switch type {
        case .expense:
            accountDBManager.substract(for: mainAccount, sum: sum)
        case .income:
            accountDBManager.add(for: mainAccount, sum: sum)
        case .transfer:
            accountDBManager.move(
                fromAccount: mainAccount,
                toAccount: corAccount!,  //swiftlint:disable:this force_unwrapping
                sum: sum
            )
        }
        
        do {
            try context.save()
            return (transaction.objectID, nil)
        } catch {
            print(error.localizedDescription)
            return (nil, ErrorMessage(error: .contextDoNotBeSaved))
        }
        
    }
    
}
