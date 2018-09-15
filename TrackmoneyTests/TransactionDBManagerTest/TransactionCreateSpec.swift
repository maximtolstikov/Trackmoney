// Для тестирования метордов создания транзакции

//swiftlint:disable force_cast

import CoreData
import Nimble
import Quick
@testable import Trackmoney

class TransactionCreateSpec: QuickSpec {
    override func spec() {
        
        var date: NSDate!
        var accountManager: AccountDBManager!
        var transactionManager: TransactionDBManager!
        let mainAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testMainName",
            .sumAccount: Int32(100)
        ]
        let corAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testCorName",
            .sumAccount: Int32(50)
        ]
        var transactionMessage: [MessageKeyType: Any] = [
            .sumTransaction: Int32(30),
            .typeTransaction: TransactionType.income.rawValue,
            .nameAccount: "testMainName",
            .iconTransaction: "iconString",
            .corAccount: "testCorName"
        ]
        
        beforeSuite {
            accountManager = AccountDBManager()
            transactionManager = TransactionDBManager()
            _ = accountManager.create(message: mainAccountMessage)
            _ = accountManager.create(message: corAccountMessage)
            date = NSDate(timeIntervalSinceNow: 0.0)
            transactionMessage[.dateTransaction] = date
        }
        
        afterSuite {
            _ = accountManager.delete(message: mainAccountMessage)
            _ = accountManager.delete(message: corAccountMessage)
            accountManager = nil
        }
        
        describe("create transaction") {
            var mainAccount: Account!
            var accountSum: Int32!
            beforeEach {
                mainAccount = accountManager.getOneObject(for: mainAccountMessage[.nameAccount] as! String)
                accountSum = mainAccount.sumAccount
            }
            
            context("for income", closure: {
                beforeEach {
                    transactionMessage[.typeTransaction] = TransactionType.income.rawValue
                }
                it("account sum should increase on 30", closure: {
                    _ = transactionManager.create(message: transactionMessage)
                    expect(mainAccount.sumAccount).to(equal(accountSum + Int32(30)))
                    _ = transactionManager.delete(message: transactionMessage)
                })
            })
            
            context("for expense", closure: {
                beforeEach {
                    transactionMessage[.typeTransaction] = TransactionType.expense.rawValue
                }
                it("account sum should increase on 30", closure: {
                    _ = transactionManager.create(message: transactionMessage)
                    expect(mainAccount.sumAccount).to(equal(accountSum - Int32(30)))
                    _ = transactionManager.delete(message: transactionMessage)
                })
            })
            
            context("for transfer", closure: {
                var corAccount: Account!
                var corAccountSum: Int32!
                beforeEach {
                    transactionMessage[.typeTransaction] = TransactionType.transfer.rawValue
                    corAccount = accountManager.getOneObject(for: corAccountMessage[.nameAccount] as! String)
                    corAccountSum = corAccount.sumAccount
                }
                it("account sum should increase on 30", closure: {
                    _ = transactionManager.create(message: transactionMessage)
                    expect(mainAccount.sumAccount).to(equal(accountSum - Int32(30)))
                    expect(corAccount.sumAccount).to(equal(corAccountSum + Int32(30)))
                    _ = transactionManager.delete(message: transactionMessage)
                })
            })
        }
        
    }
    
}
