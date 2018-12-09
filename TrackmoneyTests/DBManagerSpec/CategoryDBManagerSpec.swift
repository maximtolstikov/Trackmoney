//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
import CoreData
import XCTest
@testable import Trackmoney

class CategoryDBManagerSpec: XCTestCase {
    
    var message: [MessageKeyType: Any] = [.name: "testNameCategory",
                                          .icon: "iconString",
                                          .type: CategoryType.expense.rawValue]
    var manager: CategoryDBManager!
    
    override func setUp() {
        manager = CategoryDBManager()
    }
    override func tearDown() {
        manager = nil
    }
    
    // MARK: - create
    
    func testCreateSubCategory() throws {

        var result: (CategoryTransaction?, DBError?)!
        var childResult: (CategoryTransaction?, DBError?)!
        var childMessage: [MessageKeyType: Any]!

        try when("create Category", closure: {
            result = (manager.create(message) as! (CategoryTransaction?, DBError?))
            message[.id] = result.0?.id
        })
        try then("result.error equal nil", closure: {
            XCTAssertNil(result.1)
        })
        
        try when("create child category", closure: {
            childMessage = [
                .name: "childNameCategory",
                .icon: "iconString",
                .type: CategoryType.expense.rawValue,
                .parent: "testNameCategory"
            ]

            childResult = (manager.create(childMessage) as! (CategoryTransaction?, DBError?))
            childMessage[.id] = childResult.0?.id
        })
        try then("childResult.error equal nil", closure: {
            XCTAssertNil(childResult.1)
        })
        try then("parent have child whith name: childNameCategory", closure: {
            let predicate = NSPredicate(format: "name = %@",
                                       childMessage[.parent] as! String)
            let parentResult = manager.get(predicate)
            let parent = parentResult?.first as! CategoryTransaction
            let child = parent.child?.anyObject() as? CategoryTransaction
            let name = child?.name
            XCTAssertEqual(name, "childNameCategory")
        })
        try then("child have parent with name: testNameCategory", closure: {
            let predicate = NSPredicate(format: "id = %@",
                                        childMessage[.id] as! String)
            let newChildResult = manager.get(predicate)
            let child = newChildResult?.first as! CategoryTransaction
            let name = child.parent?.name
            XCTAssertEqual(name, "testNameCategory")
        })


        _ = manager.delete(message[.id] as! String)
        _ = manager.delete(message[.id] as! String)

    }
    
    func testCreateCategory() throws {
        
        var result: (CategoryTransaction?, DBError?)!
        
        try when("create Category", closure: {
            result = (manager.create(message) as! (CategoryTransaction?, DBError?))
            message[.id] = result.0?.id
        })
        try then("result.error equal nil", closure: {
            XCTAssertNil(result.1)
        })
        try when("create again", closure: {
            result = (manager.create(message) as! (CategoryTransaction?, DBError?))
        })
        try then("result contein error", closure: {
            let error = DBError.objectIsExistAlready
            if let resultError = result.1 {
                XCTAssertEqual(resultError, error)
            }
        })
        
        _ = manager.delete(message[.id] as! String)        
    }
    
    // MARK: - delete
    
    func testDeleteCategory() throws {
        
        var resultDelete: DBError!
        
        try given("create Category", closure: {
            let resultCreate = manager.create(message)
            message[.id] = resultCreate.0?.id
        })
        try when("delete Category", closure: {
            resultDelete = manager.delete(message[.id] as! String)
        })
        try then("result should correspond nil", closure: {
            XCTAssertNil(resultDelete)
        })
    }

    // MARK: - update
    
    func testUpdateCategory() throws {
        
        try when("create Category", closure: {
            let result = (manager.create(message) as! (CategoryTransaction?, DBError?))
            message[.id] = result.0?.id
        })
        try when("change Name", closure: {
            message[.name] = "newName"
            _ = manager.update(message)
        })
        try then("Category neme equal newName", closure: {
            let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
            let result = manager.get(predicate)
            let category = result?.first as! CategoryTransaction
            XCTAssertEqual(category.name, "newName")
        })
        
        _ = manager.delete(message[.id] as! String)        
    }
    
}
