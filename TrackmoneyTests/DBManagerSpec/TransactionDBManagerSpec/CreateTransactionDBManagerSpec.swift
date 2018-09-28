// Для описания спецификации TransactionDBManager class

//swiftlint:disable function_body_length
//swiftlint:disable force_cast

import CoreData
import Nimble
import Quick
@testable import Trackmoney

class CreateTransactionDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("Transaction methods") {
            var managerA: AccountDBManager!
            var managerT: TransactionDBManager!
            var messageAMain: [MessageKeyType: Any] = [.nameAccount: "testMainName",
                                                       .iconAccount: "iconString",
                                                       .sumAccount: Int32(100)]
            var messageACor: [MessageKeyType: Any] = [.nameAccount: "testCorName",
                                                      .iconAccount: "iconString",
                                                      .sumAccount: Int32(50)]
            var messageT: [MessageKeyType: Any] = [
                .sumTransaction: Int32(30),
                .typeTransaction: TransactionType.income.rawValue,
                .nameAccount: messageAMain[.nameAccount] as! String,
                .iconTransaction: "iconString",
                .corAccount: messageACor[.nameAccount] as! String]
            beforeEach {
                managerA = AccountDBManager()
                managerT = TransactionDBManager()
            }
            afterEach {
                managerA = nil
                managerT = nil
            }
            describe("when create", {
                var oldMainAccountSum: Int32!
                var oldCorAccountSum: Int32!
                var accountMain: Account!
                var accountCor: Account!
                beforeEach {
                    let resultMain = managerA.create(message: messageAMain)
                    let resultCor = managerA.create(message: messageACor)
                    accountMain = managerA.getObjectById(for: resultMain.0!)
                    accountCor = managerA.getObjectById(for: resultCor.0!)
                    messageAMain[.idAccount] = resultMain.0
                    messageACor[.idAccount] = resultCor.0
                    oldMainAccountSum = accountMain.sumAccount
                    oldCorAccountSum = accountCor.sumAccount
                }
                afterEach {
                    _ = managerA.delete(message: messageAMain)
                    _ = managerA.delete(message: messageACor)
                }
                describe("income", {
                    var transaction: Transaction!
                    var result: (NSManagedObjectID?, ErrorMessage?)
                    beforeEach {
                        messageT[.typeTransaction] = TransactionType.income.rawValue
                        result = managerT.create(message: messageT)
                        transaction = managerT.getObjectById(for: result.0!)
                        messageT[.idTransaction] = result.0
                    }
                    afterEach {
                        _ = managerT.delete(message: messageT)
                    }
                    it("transaction is exist", closure: {
                        expect(transaction).toNot(beNil())
                    })
                    it("mainAccount sum increase", closure: {
                        expect(accountMain.sumAccount - (messageT[.sumTransaction] as! Int32))
                            .to(equal(oldMainAccountSum))
                    })
                })
                describe("expense", {
                    var transaction: Transaction!
                    var result: (NSManagedObjectID?, ErrorMessage?)
                    beforeEach {
                        messageT[.typeTransaction] = TransactionType.expense.rawValue
                        result = managerT.create(message: messageT)
                        transaction = managerT.getObjectById(for: result.0!)
                        messageT[.idTransaction] = result.0
                    }
                    afterEach {
                        _ = managerT.delete(message: messageT)
                    }
                    it("transaction is exist", closure: {
                        expect(transaction).toNot(beNil())
                    })
                    it("mainAccount sum decrease", closure: {
                        expect(accountMain.sumAccount + (messageT[.sumTransaction] as! Int32))
                            .to(equal(oldMainAccountSum))
                    })
                    it("account sum equal 70", closure: {
                        expect(accountMain.sumAccount).to(equal(70))
                    })
                })
                describe("transfer", {
                    var transaction: Transaction!
                    var result: (NSManagedObjectID?, ErrorMessage?)
                    beforeEach {
                        messageT[.typeTransaction] = TransactionType.transfer.rawValue
                        result = managerT.create(message: messageT)
                        transaction = managerT.getObjectById(for: result.0!)
                        messageT[.idTransaction] = result.0
                    }
                    afterEach {
                        _ = managerT.delete(message: messageT)
                    }
                    it("transaction is exist", closure: {
                        expect(transaction).toNot(beNil())
                    })
                    it("mainAccount sum decrease", closure: {
                        expect(accountMain.sumAccount).to(equal(70))
                    })
                    it("corAccount sum should increase", closure: {
                        expect(accountCor.sumAccount).to(equal(80))
                    })
                })
            })
            
        }
        
    }
}
