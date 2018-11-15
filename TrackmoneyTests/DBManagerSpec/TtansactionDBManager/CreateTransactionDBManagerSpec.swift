// Для описания спецификации создания Транзакции

//swiftlint:disable sorted_imports
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class CreateTransactionDBManagerSpec: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .nameAccount: "testMainName",
        .iconAccount: "iconString",
        .sumAccount: Int32(100)]
    var messageAC: [MessageKeyType: Any] = [
        .nameAccount: "testCorName",
        .iconAccount: "iconString",
        .sumAccount: Int32(50)]
    var messageT: [MessageKeyType: Any] = [
        .sumTransaction: Int32(30),
        .nameAccount: "testMainName",
        .iconTransaction: "iconString"]
    
    var managerA: AccountDBManager!
    var managerT: TransactionDBManager!
    
    override func setUp() {
        managerA = AccountDBManager()
        managerT = TransactionDBManager()
    }
    override func tearDown() {
        managerA = nil
        managerT = nil
    }
    
    func testCreateIncomeTransaction() throws {
        
        try given("account", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
        })
        try when("create incom transaction", closure: {
            messageT[.typeTransaction] = TransactionType.income.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try then("resultGetTransaction is not nil", closure: {
            let resultGetTransaction = managerT.getObjectById(
                for: messageT[.idTransaction] as! NSManagedObjectID)
            XCTAssertNotNil(resultGetTransaction)
        })
        try then("accountMainSum equal 130", closure: {
            let account = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(account?.sumAccount, 130)
        })
        
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
    }
    
    func testCreateExpenseTransaction() throws {
        
        try given("account", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
        })
        try when("create incom transaction", closure: {
            messageT[.typeTransaction] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try then("resultGetTransaction is not nil", closure: {
            let resultGetTransaction = managerT.getObjectById(
                for: messageT[.idTransaction] as! NSManagedObjectID)
            XCTAssertNotNil(resultGetTransaction)
        })
        try then("accountMainSum equal 70", closure: {
            let account = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(account?.sumAccount, 70)
        })
        
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
    }
    
    func testCreateTransferTransaction() throws {
        
        try given("two accounts", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            let resultCreateCorAccount = managerA.create(message: messageAC)
            messageAC[.idAccount] = resultCreateCorAccount.0
            XCTAssertNotNil(resultCreateCorAccount)
        })
        try when("create incom transaction", closure: {
            messageT[.typeTransaction] = TransactionType.transfer.rawValue
            messageT[.corAccount] = "testCorName"
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try then("resultGetTransaction is not nil", closure: {
            let resultGetTransaction = managerT.getObjectById(
                for: messageT[.idTransaction] as! NSManagedObjectID)
            XCTAssertNotNil(resultGetTransaction)
        })
        try then("accountMainSum equal 70", closure: {
            let accountMain = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountMain?.sumAccount, 70)
        })
        try then("accountCorSum equal 80", closure: {
            print(messageAC[.idAccount] as! NSManagedObjectID)
            let accountCor = managerA.getObjectById(
                for: messageAC[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountCor?.sumAccount, 80)
        })
        
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
        _ = managerA.delete(message: messageAC)
    }
    
}
