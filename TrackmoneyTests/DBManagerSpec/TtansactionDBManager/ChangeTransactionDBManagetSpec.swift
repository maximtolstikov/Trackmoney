// Для описания спецификации изменения Транзакции

//swiftlint:disable sorted_imports
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class ChangeTransactionDBManagetSpec: XCTestCase {
    
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
    
    func testCangeIncomeTransaction() throws {
        
        try given("we have account and incom transaction", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            messageT[.typeTransaction] = TransactionType.income.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sumTransaction] = Int32(20)
            _ = managerT.change(message: messageT)
        })
        try then("sum account's should equal 120", closure: {
            let account = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(account?.sum, 120)
        })
        
        messageT[.sumTransaction] = Int32(30)
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
        
    }
    
    func testCangeExpenseTransaction() throws {
        
        try given("we have account and expense transaction", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            messageT[.typeTransaction] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sumTransaction] = Int32(20)
            _ = managerT.change(message: messageT)
        })
        try then("sum account's should equal 80", closure: {
            let account = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(account?.sum, 80)
        })
        
        messageT[.sumTransaction] = Int32(30)
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
        
    }
    
    func testCangeTransferTransaction() throws {
        
        try given("we have two accounts and transfer transaction", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            let resultCreateCorAccount = managerA.create(message: messageAC)
            messageAC[.idAccount] = resultCreateCorAccount.0
            messageT[.typeTransaction] = TransactionType.transfer.rawValue
            messageT[.corAccount] = messageAC[.nameAccount] as! String
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sumTransaction] = Int32(20)
            _ = managerT.change(message: messageT)
        })
        try then("sum main account's should equal 80", closure: {
            let accountMain = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountMain?.sum, 80)
        })
        try then("sum cor account's should equal 70", closure: {
            let accountCor = managerA.getObjectById(
                for: messageAC[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountCor?.sum, 70)
        })
        
        messageT[.sumTransaction] = Int32(30)
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
        _ = managerA.delete(message: messageAC)
        
    }
}
