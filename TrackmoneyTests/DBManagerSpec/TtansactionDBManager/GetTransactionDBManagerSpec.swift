// Для описания спецификации получения Транзакции

//swiftlint:disable sorted_imports
//swiftlint:disable force_unwrapping
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class GetTransactionDBManager: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .nameAccount: "testMainName",
        .iconAccount: "iconString",
        .sumAccount: Int32(100)]
    var messageT: [MessageKeyType: Any] = [
        .sumTransaction: Int32(30),
        .nameAccount: "testMainName",
        .iconTransaction: "iconString"]
    
    var managerA: AccountDBManager!
    var managerT: TransactionDBManager!
    
    override func setUp() {
        managerA = AccountDBManager()
        managerT = TransactionDBManager()
        let resultCreateMainAccount = managerA.create(message: messageAM)
        messageAM[.idAccount] = resultCreateMainAccount.0
        messageT[.typeTransaction] = TransactionType.income.rawValue
        let resultCreateTransaction = managerT.create(message: messageT)
        messageT[.idTransaction] = resultCreateTransaction.0!
        let transaction = managerT.getObjectById(for: resultCreateTransaction.0!)
        messageT[.dateTransaction] = transaction?.dateTransaction
    }
    override func tearDown() {
        _ = managerT.delete(message: messageT)
        _ = managerA.delete(message: messageAM)
        managerA = nil
        managerT = nil
    }
    
    func testGetAllTransaction() throws {
        
        var result: [NSManagedObject]?
        
        try when("get all transaction", closure: {
            result = managerT.get()
        })
        try then("result is not nil", closure: {
            XCTAssertNotNil(result)
        })
        try then("result count greater zero", closure: {
            XCTAssertGreaterThan(result!.count, 0)
        })
        
    }
    
    func testGetTransactionById() throws {
        
        var result: Transaction!

        try when("get transaction by Id", closure: {
            result = managerT.getObjectById(
                for: messageT[.idTransaction] as! NSManagedObjectID)
        })
        try then("result is not nil", closure: {
            XCTAssertNotNil(result)
        })
        
    }
    
    func testGetTransactionByDate() throws {
        
        var result: Transaction!
        
        try when("get transaction by Date", closure: {
            result = managerT.getObjectByDate(
                for: messageT[.dateTransaction] as! NSDate)
        })
        try then("result is not nil", closure: {
            XCTAssertNotNil(result)
        })
        
    }
}
