// Для тестирования методов класса TransactionDBManager

//swiftlint:disable sorted_imports


import UIKit
import XCTest
@testable import Trackmoney

class TransactionDBManagerTest: XCTestCase {

    var message: [MessageKeyType: Any]?
    var manager: TransactionDBManager?
    
    override func setUp() {
        super.setUp()
        
        let epoch = NSDate(timeIntervalSince1970: 0.0)
        
        message = [
            .dateTransaction: epoch,
            .sumTransaction: Int32(30),
            .typeTransaction: MessageTransactionType.expense.rawValue,
            .nameAccount: "testMainName",
            .iconTransaction: "testString",
            .corAccount: "testCoreName",
            .nameCategory: "testCategoryName"
        ]
        manager = TransactionDBManager()
        
    }
    
    override func tearDown() {
        
        message = nil
        manager = nil
        
        super.tearDown()
    }
    
    func testCreateTransaction() {
        
        let result = manager?.create(message: message!)
        XCTAssertTrue(result!)
        _ = manager?.delete(message: message!)
        
    }
    
}
