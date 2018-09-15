// Для тестирования методов TransactionDBManager

//swiftlint:disable force_unwrapping
//swiftlint:disable force_cast
//swiftlint:disable function_body_length

import CoreData
import Nimble
import Quick

@testable import Trackmoney

class TransactionChangeSpec: QuickSpec {
    override func spec() {
        
        var accountManager: AccountDBManager!
        
        let mainAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testMainName",
            .sumAccount: Int32(100)
        ]
        
        let corAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testCorName",
            .sumAccount: Int32(50)
        ]
        
        
        beforeSuite {
            
            accountManager = AccountDBManager()
            _ = accountManager.create(message: mainAccountMessage)
            _ = accountManager.create(message: corAccountMessage)
            
        }
        
        
        afterSuite {
            
            _ = accountManager.delete(message: mainAccountMessage)
            _ = accountManager.delete(message: corAccountMessage)
            
            accountManager = nil
            
        }
        
        
        describe("Change any fields Transaction") {
            
            var transactionMessage: [MessageKeyType: Any]!
            var changeTransactionMessage: [MessageKeyType: Any]!
            let date = NSDate(timeIntervalSinceNow: 0.0)
            var transaction: Transaction!
            var transactionManager: TransactionDBManager!
            
            
            beforeEach {
                
                transactionManager = TransactionDBManager()
                
                transactionMessage = [
                    .dateTransaction: date,
                    .sumTransaction: Int32(30),
                    .typeTransaction: TransactionType.income.rawValue,
                    .nameAccount: "testMainName",
                    .iconTransaction: "testString",
                    .corAccount: "testCorName",
                    .nameCategory: "testCategoryName"
                ]
                

                
                _ = transactionManager.create(message: transactionMessage)
                transaction = transactionManager.getOneObject(
                    for: transactionMessage[.dateTransaction] as! NSDate)!
                
            }
            
            
            afterEach {
                
                _ = transactionManager.delete(message: transactionMessage)
                transactionManager = nil
                
            }
            
            
            describe("change name Category") {
                
                changeTransactionMessage = [
                    .dateTransaction: date,
                    .typeTransaction: TransactionType.income.rawValue,
                    .nameAccount: "testMainName"
                ]
                
                context("when income type", {
                    it("transactionCategory equal newName") {
                        
                        changeTransactionMessage[.nameCategory] = "otherName"
                        _ = transactionManager.change(message: changeTransactionMessage)
                        
                        expect(transaction.nameCategory)
                            .to(equal(changeTransactionMessage[.nameCategory] as? String))
                        
                    }
                })
            }
            
            describe("change sum") {
                
                var account: Account!
                var oldSum: Int32!
                
                beforeEach {
                    changeTransactionMessage[.sumTransaction] = Int32(50)
                    account = accountManager
                        .getOneObject(for: changeTransactionMessage[.nameAccount] as! String)
                    _ = transactionManager.create(message: transactionMessage)
                    oldSum = account.sumAccount
                }
                
                afterEach {
                    _ = transactionManager.delete(message: transactionMessage)
                }
                
                context("when incom transaction", {
                    it("transaction sum equal newSum", closure: {
                        
                        
                        _ = transactionManager.change(message: changeTransactionMessage)
                        
                        expect(transaction.sumTransaction)
                            .to(equal(changeTransactionMessage[.sumTransaction] as? Int32))
                        
                    })
                    it("account sum change on delta", closure: {
                        
                        let difference = (
                            transactionMessage[.sumTransaction] as! Int32
                            ) - (changeTransactionMessage[.sumTransaction] as! Int32)
                        let newSum = oldSum - difference
                        
                        //expect(account.sumAccount).to(equal(newSum))
                    })
                })
            }
            
            
        }
        
    }
    
}
