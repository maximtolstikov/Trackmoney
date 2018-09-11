// Для тестирования методов класса TransactionDBManager

//swiftlint:disable sorted_imports
//swiftlint:disable force_unwrapping


import UIKit
import XCTest
@testable import Trackmoney

class TransactionDBManagerTest: XCTestCase {

    var transactionMessage: [MessageKeyType: Any]?
    var transactionManager: TransactionDBManager?
    var accountManager: AccountDBManager?
    
    
    override func setUp() {
        super.setUp()
        
        let epoch = NSDate(timeIntervalSinceNow: 0.0)
        
        transactionMessage = [
            .dateTransaction: epoch,
            .sumTransaction: Int32(30),
            .sumAccount: Int32(10),
            .typeTransaction: TransactionType.transfer.rawValue,
            .nameAccount: "testMainName",
            .iconTransaction: "testString",
            .corAccount: "testCorName",
            .nameCategory: "testCategoryName"
        ]
        
        transactionManager = TransactionDBManager()
        accountManager = AccountDBManager()
        
    }
    
    
    override func tearDown() {
        
        transactionMessage = nil
        transactionManager = nil
        accountManager = nil
        
        super.tearDown()
    }
    
    
    func testCreateDeleteTransaction() {
        
        var message = transactionMessage
        
        for index in 0...2 {
            
            message![.typeTransaction] = Int16(index)
            forTestCreateDeleteTransaction(message: message!)
            
        }
        
    }
    
    
    func forTestCreateDeleteTransaction(message: [MessageKeyType: Any]) {
        
        let mainAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testMainName",
            .sumAccount: Int32(100)
        ]
        let corAccountMessage: [MessageKeyType: Any] = [
            .nameAccount: "testCorName",
            .sumAccount: Int32(10)
        ]
        
        _ = accountManager?.create(message: mainAccountMessage)
        _ = accountManager?.create(message: corAccountMessage)
        
        let resultCreate = transactionManager?.create(message: message)
        XCTAssertTrue(resultCreate!)
        let resultDelete = transactionManager?.delete(message: message)
        XCTAssertTrue(resultDelete!)
        
        _ = accountManager?.delete(message: mainAccountMessage)
        _ = accountManager?.delete(message: corAccountMessage)
        
    }
    
}
