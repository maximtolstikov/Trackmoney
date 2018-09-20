// Для описания спецификации методов сущьности "Счет"

//swiftlint:disable force_unwrapping
//swiftlint:disable function_body_length
//swiftlint:disable force_cast

import CoreData
import Nimble
import Quick
@testable import Trackmoney

class AccountDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("Account") {
            var message: [MessageKeyType: Any] = [.nameAccount: "testMainName",
                                                  .iconAccount: "iconString",
                                                  .sumAccount: Int32(100)]
            describe("when create", {
                var manager: AccountDBManager!
                beforeEach {
                    manager = AccountDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("error should be nil", closure: {
                    let result = manager.create(message: message)
                    message[.idAccount] = result.0
                    expect(result.1).to(beNil())
                    _ = manager.delete(message: message)
                })
                it("sum should be equal 100", closure: {
                    let result = manager.create(message: message)
                    message[.idAccount] = result.0
                    let sut = manager.getObjectById(for: result.0!)
                    expect(sut?.sumAccount).to(equal(100))
                    _ = manager.delete(message: message)
                })
                it("name should be equal testMainName", closure: {
                    let result = manager.create(message: message)
                    message[.idAccount] = result.0
                    let sut = manager.getObjectById(for: result.0!)
                    expect(sut?.nameAccount).to(equal("testMainName"))
                    _ = manager.delete(message: message)
                })
                it ("if create again should be retrive error") {
                    let result = manager.create(message: message)
                    let errorResult = manager.create(message: message)
                    message[.idAccount] = result.0
                    expect(errorResult.1?.error.rawValue)
                        .to(equal(TextErrors.accountIsExistAlready.rawValue))
                    _ = manager.delete(message: message)
                }
            })
            
            
            describe("when get all", {
                var accountManager: AccountDBManager!
                var result: [NSManagedObject]?
                beforeEach {
                    accountManager = AccountDBManager()
                    _ = accountManager.create(message: message)
                    result = accountManager.get() as? [Account]
                }
                afterEach {
                    let account = result![0] as! Account
                    let id = account.objectID
                    message[.idAccount] = id
                    _ = accountManager.delete(message: message)
                    accountManager = nil
                }
                it("count result should be greater 0", closure: {
                    expect(result?.count).to(beGreaterThan(0))
                })
                it("count result should be less then 2", closure: {
                    expect(result?.count).to(beLessThan(2))
                })
            })
            
            describe("when get only one account", {
                var manager: AccountDBManager!
                beforeEach {
                    manager = AccountDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("should retrive Account by name", closure: {
                    let result = manager.create(message: message)
                    message[.idAccount] = result.0
                    let account = manager.getObjectByName(
                        for: message[.nameAccount] as! String)
                    expect(account).to(beAKindOf(Account.self))
                    _ = manager.delete(message: message)
                })
                it("should retrive Account by name", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    message[.idAccount] = result.0
                    let account = manager.getObjectById(
                        for: id!)
                    expect(account).to(beAKindOf(Account.self))
                    _ = manager.delete(message: message)
                })
            })
            
            describe("when change", {
                var manager: AccountDBManager!
                var changeMessage: [MessageKeyType: Any] = [
                    .nameAccount: "newName",
                    .iconAccount: "newIconString"
                ]
                beforeEach {
                    manager = AccountDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("after change name equal newName", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    changeMessage[.idAccount] = id
                    let account = manager.getObjectById(
                        for: changeMessage[.idAccount] as! NSManagedObjectID)
                    _ = manager.change(message: changeMessage)
                    expect(account?.nameAccount)
                        .to(equal(changeMessage[.nameAccount] as? String))
                    _ = manager.delete(message: changeMessage)
                })
                it("after change icon equal newIcon", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    changeMessage[.idAccount] = id
                    let account = manager.getObjectById(
                        for: changeMessage[.idAccount] as! NSManagedObjectID)
                    _ = manager.change(message: changeMessage)
                    expect(account?.iconAccount)
                        .to(equal(changeMessage[.iconAccount] as? String))
                    _ = manager.delete(message: changeMessage)
                })
            })
        }
    }
}
