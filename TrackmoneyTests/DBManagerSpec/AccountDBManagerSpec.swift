//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData
import XCTest
@testable import Trackmoney

class AccountDBManagerSpec: XCTestCase {
    
    var message: [MessageKeyType: Any] = [.name: "testMainName",
                                          .icon: "icon",
                                          .sum: Int32(100)]
    var manager: AccountDBManager!
    
    override func setUp() {
        manager = AccountDBManager()
    }
    override func tearDown() {
        manager = nil
    }
    
    // MARK: - create
    
    func testCreateAccount() throws {
        
        var result: (Account?, DBError?)!
        
        try when("create Account", closure: {
            result = manager.create(message) as? (Account?, DBError?)
            message[.id] = result.0?.id
        })
        try then("result.error equal nil", closure: {
            XCTAssertNil(result.1)
        })
        try then("created account name equal message.name", closure: {
            XCTAssertEqual(result.0?.name, message[.name] as? String)
        })
        
        _ = manager.delete(message[.id] as! String)
        
    }

    // MARK: - delete
    
    func testDeleteAccount() throws {
        
        var resultDelete: DBError?
        
        try given("create Account", closure: {
            let resultCreate = manager.create(message)
            message[.id] = resultCreate.0?.id
        })
        try when("delete Account", closure: {
            resultDelete = manager.delete(message[.id] as! String)
        })
        try then("result should correspond nil", closure: {
            XCTAssertNil(resultDelete)
        })
        try then("object ib base isn't exist, should empty result", closure: {
            let predicate = NSPredicate(format: "name = %@", message[.name] as! String)
            let result = manager.get(predicate)            
            XCTAssertTrue((result?.isEmpty)!)
        })
        
    }
    
        // MARK: - get
    
        func testGetAcconts() throws {
    
            var result: [DBEntity]?
    
            try given("Account", closure: {
                let resultCreate = manager.create(message)
                message[.id] = resultCreate.0?.id
            })
            try when("get Account by name") {
            let predicate = NSPredicate(format: "name = %@", message[.name] as! String)
                result = manager.get(predicate)
            }
            try then("account.name equal messege.name", closure: {
                let account = result?.first as! Account
                XCTAssertEqual(account.name, message[.name] as! String)
            })
            try then("shold be one result", closure: {
                let count = result?.count
                XCTAssertEqual(count, 1)
            })
    
            _ = manager.delete(message[.id] as! String)
        }

    // MARK: - update
    
    func testUpdateAccount() throws {
        
        try given("Account", closure: {
            let resultCreate = manager.create(message)
            message[.id] = resultCreate.0?.id
        })
        try when("change Name", closure: {
            message[.name] = "newName"
            message[.icon] = "newIcon"
            _ = manager.update(message)
        })
        try then("account neme equal newName", closure: {
            let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
            let result = manager.get(predicate)
            let account = result?.first as! Account
            XCTAssertEqual(account.name, "newName")
            XCTAssertEqual(account.icon, "newIcon")
        })
        
        _ = manager.delete(message[.id] as! String)
        
    }
    
}
