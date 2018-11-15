// Для спецификации класса работы Счетов с базой данных

//swiftlint:disable sorted_imports
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class AccountDBManagerSpec: XCTestCase {
    
    var message: [MessageKeyType: Any] = [.nameAccount: "testMainName",
                                          .iconAccount: "iconString",
                                          .sumAccount: Int32(100)]
    var manager: AccountDBManager!
    
    override func setUp() {
        manager = AccountDBManager()
    }
    override func tearDown() {
        manager = nil
    }
    
    // MARK: - create
    
    func testCreateAccount() throws {
        
        var result: (NSManagedObjectID?, ErrorMessage?)!
        
        try given("create Account", closure: {
            result = manager.create(message: message)
            message[.idAccount] = result.0
        })
        try then("result.error equal nil", closure: {
            XCTAssertNil(result.1)
        })
        
        _ = manager.delete(message: message)
        
    }
    
    // MARK: - delete
    
    func testDeleteAccount() throws {
        
        var resultDelete: ErrorMessage!
        
        try given("create Account", closure: {
            let resultCreate = manager.create(message: message)
            message[.idAccount] = resultCreate.0
        })
        try when("delete Account", closure: {
            resultDelete = manager.delete(message: message)
        })
        try then("result should correspond nil", closure: {
            XCTAssertNil(resultDelete)
        })
        
    }
    
    // MARK: - change
    
    func testChangeNameAccount() throws {
        
        try given("Account", closure: {
            let resultCreate = manager.create(message: message)
            message[.idAccount] = resultCreate.0
        })
        try when("change Name", closure: {
            message[.nameAccount] = "newName"
            _ = manager.change(message: message)
        })
        try then("account neme equal newName", closure: {
            let account = manager.getObjectById(
                for: message[.idAccount] as! NSManagedObjectID)
            XCTAssertEqual(account?.nameAccount, "newName")
        })
        
        _ = manager.delete(message: message)
        
    }
    
    // MARK: - get
    
    func testGetAllAcconts() throws {
        
        var resultGetAll: [NSManagedObject]?
        
        try given("Account", closure: {
            let resultCreate = manager.create(message: message)
            message[.idAccount] = resultCreate.0
        })
        try when("get all Account") {
            resultGetAll = manager.get()
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetAll)
        })
        
        _ = manager.delete(message: message)
    }
    
    func testGetOneAccountById() throws {
        
        var resultGetOne: Account?
        
        try given("Account", closure: {
            let resultCreate = manager.create(message: message)
            message[.idAccount] = resultCreate.0
        })
        try when("get Account by Id") {
            resultGetOne = manager.getObjectById(
                for: message[.idAccount] as! NSManagedObjectID)
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetOne)
        })
        
        _ = manager.delete(message: message)
    }
    
    func testGetOneAccountByName() throws {
        
        var resultGetOne: Account?
        
        try given("Account", closure: {
            let resultCreate = manager.create(message: message)
            message[.idAccount] = resultCreate.0
        })
        try when("get Account by Id") {
            resultGetOne = manager.getObjectByName(
                for: message[.nameAccount] as! String)
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetOne)
        })
        
        _ = manager.delete(message: message)
    }
    
}
