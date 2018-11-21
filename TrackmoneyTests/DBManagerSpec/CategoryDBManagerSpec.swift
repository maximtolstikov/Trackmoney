// Для описания спецификации работы Категорий с БД

//swiftlint:disable sorted_imports
//swiftlint:disable force_cast

import CoreData
import XCTest
@testable import Trackmoney

class CategoryDBManagerSpec: XCTestCase {
    
    var message: [MessageKeyType: Any] = [.nameCategory: "testNameCategory",
                                          .iconCategory: "iconString",
                                          .typeCategory: CategoryType.expense.rawValue]
    var manager: CategoryDBManager!
    
    override func setUp() {
        manager = CategoryDBManager()
    }
    override func tearDown() {
        manager = nil
    }
    
    // MARK: - create
    
    func testCreateCategory() throws {
        
        var result: (NSManagedObjectID?, ErrorMessage?)!
        
        try given("create Category", closure: {
            result = manager.create(message: message)
            message[.idCategory] = result.0
        })
        try then("result.error equal nil", closure: {
            XCTAssertNil(result.1)
        })
        try when("create again", closure: {
            result = manager.create(message: message)
        })
        try then("result contein error", closure: {
            let error = ErrorMessage(error: .categoryIsExistAlready)
            if let resultError = result.1 {
                XCTAssertEqual(resultError, error)
            }
        })
        
        _ = manager.delete(message: message)
        
    }
    
    // MARK: - delete
    
    func testDeleteCategory() throws {
        
        var resultDelete: ErrorMessage!
        
        try given("create Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("delete Category", closure: {
            resultDelete = manager.delete(message: message)
        })
        try then("result should correspond nil", closure: {
            XCTAssertNil(resultDelete)
        })
        
    }
    
    // MARK: - change
    
    func testChangeNameCategory() throws {
        
        try given("Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("change Name", closure: {
            message[.nameCategory] = "newName"
            _ = manager.change(message: message)
        })
        try then("Category neme equal newName", closure: {
            let category = manager.getObjectById(
                for: message[.idCategory] as! NSManagedObjectID)
            XCTAssertEqual(category?.name, "newName")
        })
        
        _ = manager.delete(message: message)
        
    }
    
    func testChangeIconCategory() throws {
        
        try given("Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("change icon", closure: {
            message[.iconCategory] = "newPath"
            _ = manager.change(message: message)
        })
        try then("Category icon equal newPath", closure: {
            let category = manager.getObjectById(
                for: message[.idCategory] as! NSManagedObjectID)
            XCTAssertEqual(category?.iconCategory, "newPath")
        })
        
        _ = manager.delete(message: message)
        
    }
    
    // MARK: - get
    
    func testGetAllCategory() throws {
    
        var resultGetAll: [NSManagedObject]?
        
        try given("Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("get all Category") {
            resultGetAll = manager.get()
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetAll)
        })
            
            _ = manager.delete(message: message)
    }
    
    func testGetOneCategoryById() throws {
        
        var resultGetOne: CategoryTransaction?
        
        try given("Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("get Category by Id") {
            resultGetOne = manager.getObjectById(
                for: message[.idCategory] as! NSManagedObjectID)
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetOne)
        })
        
        _ = manager.delete(message: message)
    }
    
    func testGetOneCategoryByName() throws {
        
        var resultGetOne: CategoryTransaction?
        
        try given("Category", closure: {
            let resultCreate = manager.create(message: message)
            message[.idCategory] = resultCreate.0
        })
        try when("get Category by Id") {
            resultGetOne = manager.getObjectByName(
                for: message[.nameCategory] as! String)
        }
        try then("result is not nil", closure: {
            XCTAssertNotNil(resultGetOne)
        })
        
        _ = manager.delete(message: message)
    }
    
}
