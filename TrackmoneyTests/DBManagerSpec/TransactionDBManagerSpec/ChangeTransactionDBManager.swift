// Для описания спецификации метода сhange TransactionDBManager

//swiftlint:disable force_cast
//swiftlint:disable function_body_length

import Nimble
import Quick
@testable import Trackmoney

class ChangeTransactionDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("Change transaction") {
            
            var managerA: AccountDBManager!
            var managerT: TransactionDBManager!
            
            var messageAMain: [MessageKeyType: Any] = [
                .nameAccount: "testMainName",
                .iconAccount: "iconString",
                .sumAccount: Int32(100)]
            var messageACor: [MessageKeyType: Any] = [
                .nameAccount: "testCorName",
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
                
                let resultMain = managerA.create(message: messageAMain)
                let resultCor = managerA.create(message: messageACor)
                messageAMain[.idAccount] = resultMain.0
                messageACor[.idAccount] = resultCor.0                
            }
            afterEach {
                _ = managerA.delete(message: messageAMain)
                _ = managerA.delete(message: messageACor)
            }
            
            describe("change sum income", {
                beforeEach {
                    messageT[.typeTransaction] = TransactionType.income.rawValue
                    let result = managerT.create(message: messageT)
                    messageT[.idTransaction] = result.0
                    let transaction = managerT.getObjectById(for: result.0!)
                    messageT[.dateTransaction] = transaction?.dateTransaction
                }
                afterEach {
                    _ = managerT.delete(message: messageT)
                }
                it("transaction is exist", closure: {
                    let result = managerT.getObjectByDate(for: messageT[.dateTransaction] as! NSDate)
                    expect(result).toNot(beNil())
                })
                it("main account equal 130", closure: {
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(130))
                })
                it("after change transaction sum equal 120", closure: {
                    messageT[.sumTransaction] = Int32(20)
                    _ = managerT.change(message: messageT)
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(120))
                })
            })
            
            describe("change sum expense", {
                beforeEach {
                    messageT[.typeTransaction] = TransactionType.expense.rawValue
                    messageT[.sumTransaction] = Int32(30)
                    let result = managerT.create(message: messageT)
                    messageT[.idTransaction] = result.0
                    let transaction = managerT.getObjectById(for: result.0!)
                    messageT[.dateTransaction] = transaction?.dateTransaction
                }
                afterEach {
                    _ = managerT.delete(message: messageT)
                }
                it("transaction is exist", closure: {
                    let result = managerT.getObjectByDate(for: messageT[.dateTransaction] as! NSDate)
                    expect(result).toNot(beNil())
                })
                it("main account equal 70", closure: {
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(70))
                })
                it("after change transaction sum equal 80", closure: {
                    messageT[.sumTransaction] = Int32(20)
                    _ = managerT.change(message: messageT)
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(80))
                })
            })
            
            describe("change sum transfer", {
                beforeEach {
                    messageT[.typeTransaction] = TransactionType.transfer.rawValue
                    messageT[.sumTransaction] = Int32(30)
                    messageAMain[.sumAccount] = Int32(100)
                    let result = managerT.create(message: messageT)
                    messageT[.idTransaction] = result.0
                    let transaction = managerT.getObjectById(for: result.0!)
                    messageT[.dateTransaction] = transaction?.dateTransaction
                }
                afterEach {
                    _ = managerT.delete(message: messageT)
                }
                it("transaction is exist", closure: {
                    let result = managerT.getObjectByDate(for: messageT[.dateTransaction] as! NSDate)
                    expect(result).toNot(beNil())
                })
                it("main account equal 70, cor equal 80", closure: {
                    let accountM = managerA.getObjectByName(for: "testMainName")
                    let accountC = managerA.getObjectByName(for: "testCorName")
                    expect(accountM?.sumAccount).to(equal(70))
                    expect(accountC?.sumAccount).to(equal(80))
                })
                it("after change transaction sum equal 80, 70", closure: {
                    let accountM = managerA.getObjectByName(for: "testMainName")
                    let accountC = managerA.getObjectByName(for: "testCorName")
                    messageT[.sumTransaction] = Int32(20)
                    _ = managerT.change(message: messageT)                    
                    expect(accountM?.sumAccount).to(equal(80))
                    expect(accountC?.sumAccount).to(equal(70))
                })
            })
            
        }
        
    }
}
