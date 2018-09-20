// Для тестирования методов TransactionDBManager



import CoreData
import Nimble
import Quick

@testable import Trackmoney

class TransactionChangeSpec: QuickSpec {
    override func spec() {

//        beforeSuite {
//                            let mainAccountMessage: [MessageKeyType: Any] = [
//                                .nameAccount: "testMainName",
//                                .sumAccount: Int32(100)
//                            ]
//                            let corAccountMessage: [MessageKeyType: Any] = [
//                                .nameAccount: "testCorName",
//                                .sumAccount: Int32(80)
//                            ]
//            
//                            let accountManager = AccountDBManager()
//                            _ = accountManager.create(message: mainAccountMessage)
//                            _ = accountManager.create(message: corAccountMessage)
//        }
//        
//        describe("methods change transaction") {
//            let accountManager = AccountDBManager()
//            let mainAccount = accountManager.getOneObject(for: "testCorName")
//            let sum = mainAccount?.sumAccount
//        }
        
//        describe("change transaction methods") {
//            beforeEach {
//

//                            mainAccount = accountManager
//                                .getOneObject(for: mainAccountMessage[.nameAccount] as! String)
//                            corAccount = accountManager
//                                .getOneObject(for: corAccountMessage[.nameAccount] as! String)
//
//                            transactionManager = TransactionDBManager()
//                            transactionMessage[.dateTransaction] = date
//                            _ = transactionManager.create(message: transactionMessage)
//                            transaction = transactionManager.getOneObject(for: date)
//                
//    
//                let account = accountManager
//                    .getOneObject(for: "testMainName")
//                let mainAccountSum = account?.sumAccount
//
//            }
//
//            afterEach {
//
//                            let transactionManager = TransactionDBManager()
//                let accountManager = AccountDBManager()
//
//                                        let transactionMessage: [MessageKeyType: Any] = [
//                                            .sumTransaction: Int32(0),
//                                            .typeTransaction: TransactionType.income.rawValue,
//                                            .nameAccount: "testMainName",
//                                            .iconTransaction: "iconString",
//                                            .corAccount: "testCorName"
//                                        ]
//                let mainAccountMessage: [MessageKeyType: Any] = [
//                    .nameAccount: "testMainName",
//                    .sumAccount: Int32(100)
//                ]
//                let corAccountMessage: [MessageKeyType: Any] = [
//                    .nameAccount: "testCorName",
//                    .sumAccount: Int32(50)
//                ]
//
//                            _ = transactionManager.delete(message: transactionMessage)
//                _ = accountManager.delete(message: mainAccountMessage)
//                _ = accountManager.delete(message: corAccountMessage)
//
//            }
//
//                        let transactionManager = TransactionDBManager()
//                        let accountManager = AccountDBManager()
//                        let date = NSDate(timeIntervalSinceNow: 0.0)
//
//                        var transactionMessage: [MessageKeyType: Any] = [
//                            .dateTransaction: date,
//                            .sumTransaction: Int32(30),
//                            .typeTransaction: TransactionType.income.rawValue,
//                            .nameAccount: "testMainName",
//                            .iconTransaction: "iconString",
//                            .corAccount: "testCorName"
//                        ]
//
//            describe("change sum", closure: {
//                                let account = accountManager
//                                    .getOneObject(for: "testMainName")
//                                let mainAccountSum = account?.sumAccount
//                                context("for income transaction", {
//                                    beforeEach {
//                                        _ = transactionManager.create(message: transactionMessage)
//                                    }
//                                    afterEach {
//                                        _ = transactionManager.delete(message: transactionMessage)
//                                    }
//
//                                    it("sum should increase on 30", closure: {
//
//                                        expect(account?.sumAccount).to(equal(mainAccountSum! + 30))
//                                    })
//                                })
//
//                                let changeTransactionMessage: [MessageKeyType: Any] = [
//                                    .dateTransaction: date,
//                                    .sumTransaction: Int32(10)
//                                ]
//                                let sumMainAccount = mainAccount.sumAccount
//                                let sumNewTransaction = changeTransactionMessage[.sumTransaction] as! Int32
//                                _ = transactionManager.change(message: changeTransactionMessage)
//
//                                expect(mainAccount.sumAccount).to(equal(sumMainAccount + sumNewTransaction))
//
//
//            })
//
//        }
        
    }
    
}
