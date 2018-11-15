// Для описания спецификации удаления Транзакции

//swiftlint:disable sorted_imports
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class DeleteTransactionDBManagetSpec: XCTestCase {
    
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
    
    func testDeleteIncomeTransaction() throws {
        
        var accountMain: Account!
        
        try given("account and after transaction income sum equal 130", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            messageT[.typeTransaction] = TransactionType.income.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
            accountMain = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountMain?.sumAccount, 130)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(message: messageT)
        })
        try then("sum Account equal 100 again", closure: {
            XCTAssertEqual(accountMain.sumAccount, 100)
        })
        
        _ = managerA.delete(message: messageAM)
        
    }
    
    func testDeleteExpenseTransaction() throws {
        
        var accountMain: Account!
        
        try given("account and after transaction income sum equal 70", closure: {
            let resultCreateMainAccount = managerA.create(message: messageAM)
            messageAM[.idAccount] = resultCreateMainAccount.0
            messageT[.typeTransaction] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(message: messageT)
            messageT[.idTransaction] = resultCreateTransaction.0!
            accountMain = managerA.getObjectById(
                for: messageAM[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(accountMain?.sumAccount, 70)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(message: messageT)
        })
        try then("sum Account equal 100 again", closure: {
            XCTAssertEqual(accountMain.sumAccount, 100)
        })
        
        _ = managerA.delete(message: messageAM)
        
    }
    
    func testTranserIncomeTransaction() throws {
        
        var accountMain: Account!
        var accountCor: Account!
        
        try given("two accounts and after transaction transfer sumM equal 70, sumC 80 ",
                  closure: {
                    let resultCreateMainAccount = managerA.create(message: messageAM)
                    messageAM[.idAccount] = resultCreateMainAccount.0
                    let resultCreateCorAccount = managerA.create(message: messageAC)
                    messageAC[.idAccount] = resultCreateCorAccount.0
                    accountMain = managerA.getObjectById(
                        for: messageAM[.idAccount] as! NSManagedObjectID)
                    accountCor = managerA.getObjectById(
                        for: messageAC[.idAccount] as! NSManagedObjectID)
                    messageT[.typeTransaction] = TransactionType.transfer.rawValue
                    messageT[.corAccount] = accountCor.nameAccount
                    let resultCreateTransaction = managerT.create(message: messageT)
                    messageT[.idTransaction] = resultCreateTransaction.0!
                    XCTAssertEqual(accountMain?.sumAccount, 70)
                    XCTAssertEqual(accountCor?.sumAccount, 80)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(message: messageT)
        })
        try then("sum AccountMain equal 100 and sum Cor 50 again", closure: {
            XCTAssertEqual(accountMain.sumAccount, 100)
            XCTAssertEqual(accountCor.sumAccount, 50)
        })
        
        _ = managerA.delete(message: messageAM)
        _ = managerA.delete(message: messageAC)
        
    }
    
}
