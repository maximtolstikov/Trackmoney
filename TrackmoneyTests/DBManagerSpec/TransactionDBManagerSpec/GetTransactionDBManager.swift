// Для описания спецификации GetTransactionDBManager class

//swiftlint:disable force_cast
//swiftlint:disable function_body_length

import CoreData
import Nimble
import Quick
@testable import Trackmoney

class GetTransactionDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("Transaction") {
            var managerA: AccountDBManager!
            var managerT: TransactionDBManager!
            var messageAMain: [MessageKeyType: Any] = [.nameAccount: "testMainName",
                                                       .iconAccount: "iconString",
                                                       .sumAccount: Int32(100)]
            var messageT: [MessageKeyType: Any] = [
                .sumTransaction: Int32(30),
                .typeTransaction: TransactionType.income.rawValue,
                .nameAccount: messageAMain[.nameAccount] as! String,
                .iconTransaction: "iconString"]
            var resultA: (NSManagedObjectID?, ErrorMessage?)
            var resultT: (NSManagedObjectID?, ErrorMessage?)
            beforeEach {
                managerA = AccountDBManager()
                managerT = TransactionDBManager()
                resultA = managerA.create(message: messageAMain)
                resultT = managerT.create(message: messageT)
                messageAMain[.idAccount] = resultA.0
                messageT[.idTransaction] = resultT.0
                let transaction = managerT.getObjectById(for: resultT.0!)
                messageT[.dateTransaction] = transaction?.dateTransaction
            }
            afterEach {                
                _ = managerT.delete(message: messageT)
                _ = managerA.delete(message: messageAMain)
                managerA = nil
                managerT = nil
            }
            describe("get all", {
                var getResult: [Transaction]?
                beforeEach {
                    getResult = managerT.get() as? [Transaction]
                }
                it("count result should be greater 0", closure: {
                    expect(getResult?.count).to(beGreaterThan(0))
                })
                it("count result should be less then 2", closure: {
                    expect(getResult?.count).to(beLessThan(2))
                    
                })
            })
            describe("get by id", {
                var getResult: Transaction?
                beforeEach {
                    getResult = managerT.getObjectById(
                        for: messageT[.idTransaction] as! NSManagedObjectID)
                }
                it("result is not nil", closure: {
                    expect(getResult).toNot(beNil())
                })
            })
            describe("get by date", {
                var getResult: Transaction?
                beforeEach {
                    getResult = managerT.getObjectByDate(
                        for: messageT[.dateTransaction] as! NSDate)
                }
                it("result is not nil", closure: {
                    expect(getResult).toNot(beNil())
                })
            })
        }
    }
}
