// Для тестирования методов класса AccountDBManager

//swiftlint:disable sorted_imports
//swiftlint:disable force_unwrapping

import UIKit
import XCTest
@testable import Trackmoney

class AccountDBManagerTest: XCTestCase {

    var message: [MessageKeyType: Any]?
    var manager: AccountDBManager?
    
    override func setUp() {
        super.setUp()
        
        message = [.nameAccount: "testName", .sumAccount: Int32(30), .iconAccount: "testIcon"]
        manager = AccountDBManager()
        
    }
    
    override func tearDown() {
        
        message = nil
        manager = nil
                
        super.tearDown()
    }
    
    func testCreateAccount() {

        let result = manager?.create(message: message!)
        XCTAssertTrue(result!)
        _ = manager?.delete(message: message!)

    }


    func testGetAccount() {

        _ = manager?.create(message: message!)
        let result = manager?.getOneObject(for: message![.nameAccount] as! String)
        XCTAssertNotNil(result)
        _ = manager?.delete(message: message!)

    }


    func testGetAllAccount() {

        _ = manager?.create(message: message!)
        let result = manager?.get()
        XCTAssertFalse((result?.isEmpty)!)
        _ = manager?.delete(message: message!)

    }


    func testChangeAccount() {

        let newMessage: [MessageKeyType: Any] = [
                                                 .nameAccount: "testName",
                                                 .sumAccount: Int32(50),
                                                 .iconAccount: "testIconOther" ]
        _ = manager?.create(message: message!)
        let result = manager?.change(message: newMessage)
        XCTAssertTrue(result!)
        _ = manager?.delete(message: message!)

    }


    func testDeleteAccount() {

        _ = manager?.create(message: message!)
        let result = manager?.delete(message: message!)
        XCTAssertTrue(result!)

    }

}
