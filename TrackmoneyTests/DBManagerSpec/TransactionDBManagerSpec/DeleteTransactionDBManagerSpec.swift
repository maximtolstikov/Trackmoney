// Для описания спецификации DeleteTransactionDBManager class

//swiftlint:disable force_cast
//swiftlint:disable function_body_length

import Nimble
import Quick
@testable import Trackmoney

class DeleteTransactionDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("delete") {
            
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
            
            describe("income", {
                it("account sum equal 100", closure: {
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(100))
                })
                it("after create transaction sum equal 130", closure: {
                    let result = managerT.create(message: messageT)
                    messageT[.idTransaction] = result.0!
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(130))
                })
                it("after delete transaction sum equal 70", closure: {
                    _ = managerT.delete(message: messageT)
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(70))
                })
            })
            
            describe("expense", {
                it("after create transaction sum equal 70", closure: {
                    messageT[.typeTransaction] = TransactionType.expense.rawValue
                    let result = managerT.create(message: messageT)
                    messageT[.idTransaction] = result.0!
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(70))
                })
                it("after delete transaction sum equal 130", closure: {
                    _ = managerT.delete(message: messageT)
                    let account = managerA.getObjectByName(for: "testMainName")
                    expect(account?.sumAccount).to(equal(130))
                })
            })
            
            describe("transfer", {
                context("for main and cor account", {
                    it("after create transaction sum equal 70 and 80", closure: {
                        messageT[.typeTransaction] = TransactionType.transfer.rawValue
                        let result = managerT.create(message: messageT)
                        messageT[.idTransaction] = result.0!
                        let accountM = managerA.getObjectByName(for: "testMainName")
                        let accountC = managerA.getObjectByName(for: "testCorName")
                        expect(accountM?.sumAccount).to(equal(70))
                        expect(accountC?.sumAccount).to(equal(80))
                    })
                    it("after delete transaction sum equal 130 and 20", closure: {
                        _ = managerT.delete(message: messageT)
                        let accountM = managerA.getObjectByName(for: "testMainName")
                        let accountC = managerA.getObjectByName(for: "testCorName")
                        expect(accountM?.sumAccount).to(equal(130))
                        expect(accountC?.sumAccount).to(equal(20))
                    })
                })
            })
            
        }
    }
}
