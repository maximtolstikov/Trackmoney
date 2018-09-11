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
        
        self.date = message[.dateTransaction] as! NSDate
        self.sum = message[.sumTransaction] as! Int32
        self.iconTransaction = message[.iconTransaction] as! String
        
        guard let type = TransactionType(
            rawValue: message[.typeTransaction] as! Int16),
            let accountMain = accountDBManager.getOneObject(
                for: message[.nameAccount] as! String) else {
                    assertionFailure()
                    return nil }
        
        self.type = type
        self.mainAccount = accountMain
        
        if mManager.isExistValue(for: .nameCategory, in: message) {
            self.category = message[.nameCategory] as? String
        }
        if mManager.isExistValue(for: .corAccount, in: message) {
            guard let accountCor = accountDBManager.getOneObject(
                for: message[.corAccount] as! String) else {
                    assertionFailure()
                    return nil }
            self.corAccount = accountCor
        }
        
    }
    
    
    func execute() -> Bool {
        
        let transaction = Transaction(context: context)
        transaction.dateTransaction = date
        transaction.sumTransaction = sum
        transaction.typeTransaction = type.rawValue
        transaction.nameAccount = mainAccount.nameAccount
        transaction.iconTransaction = iconTransaction
        transaction.nameCategory = category
        transaction.corAccount = corAccount?.nameAccount
        
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
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
}
