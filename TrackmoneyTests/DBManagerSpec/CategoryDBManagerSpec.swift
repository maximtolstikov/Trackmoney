// Для описания спецификации CategoryDBManager

//swiftlint:disable force_unwrapping
//swiftlint:disable force_cast
//swiftlint:disable function_body_length

import CoreData
import Nimble
import Quick
@testable import Trackmoney

class CategoryDBManagerSpec: QuickSpec {
    override func spec() {
        
        describe("Category methods") {
            var message: [MessageKeyType: Any] = [.nameCategory: "testNameCategory",
                                                  .iconCategory: "iconString"
                                                 ]            
            describe("when create", {
                var manager: CategoryDBManager!
                beforeEach {
                    manager = CategoryDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("error should be nil", closure: {
                    let result = manager.create(message: message)
                    message[.idCategory] = result.0
                    expect(result.1).to(beNil())
                    _ = manager.delete(message: message)
                })
                it("name should be equal testNameCategory", closure: {
                    let result = manager.create(message: message)
                    message[.idCategory] = result.0
                    let sut = manager.getObjectById(for: result.0!)
                    expect(sut?.nameCategory).to(equal("testNameCategory"))
                    _ = manager.delete(message: message)
                })
                it ("if create again should be retrive error") {
                    let result = manager.create(message: message)
                    let errorResult = manager.create(message: message)
                    message[.idCategory] = result.0
                    expect(errorResult.1?.error.rawValue)
                        .to(equal(TextErrors.categoryIsExistAlready.rawValue))
                    _ = manager.delete(message: message)
                }
            })
            
            
            describe("when get all", {
                var manager: CategoryDBManager!
                var result: [NSManagedObject]?
                beforeEach {
                    manager = CategoryDBManager()
                    _ = manager.create(message: message)
                    result = manager.get()
                }
                afterEach {
                    let category = result![0]
                    let id = category.objectID
                    message[.idCategory] = id
                    _ = manager.delete(message: message)
                    manager = nil
                }
                it("count result should be greater 0", closure: {
                    expect(result?.count).to(beGreaterThan(0))
                })
                it("count result should be less then 2", closure: {
                    expect(result?.count).to(beLessThan(2))
                })
            })
            
            describe("when get only one category", {
                var manager: CategoryDBManager!
                beforeEach {
                    manager = CategoryDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("should retrive Category by name", closure: {
                    let result = manager.create(message: message)
                    message[.idCategory] = result.0
                    let category = manager.getObjectByName(
                        for: message[.nameCategory] as! String)
                    expect(category).to(beAKindOf(Category.self))
                    _ = manager.delete(message: message)
                })
                it("should retrive Category by name", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    message[.idCategory] = result.0
                    let category = manager.getObjectById(
                        for: id!)
                    expect(category).to(beAKindOf(Category.self))
                    _ = manager.delete(message: message)
                })
            })

            describe("when change", {
                var manager: CategoryDBManager!
                var changeMessage: [MessageKeyType: Any] = [
                    .nameCategory: "newName",
                    .iconCategory: "newIconString"
                ]
                beforeEach {
                    manager = CategoryDBManager()
                }
                afterEach {
                    manager = nil
                }
                it("after change name equal newName", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    changeMessage[.idCategory] = id
                    _ = manager.change(message: changeMessage)
                    let category = manager.getObjectById(
                        for: changeMessage[.idCategory] as! NSManagedObjectID)
                    expect(category?.nameCategory)
                        .to(equal(changeMessage[.nameCategory] as? String))
                    _ = manager.delete(message: changeMessage)
                })
                it("after change icon equal newIcon", closure: {
                    let result = manager.create(message: message)
                    let id = result.0
                    changeMessage[.idCategory] = id
                    let category = manager.getObjectById(
                        for: changeMessage[.idCategory] as! NSManagedObjectID)
                    _ = manager.change(message: changeMessage)
                    expect(category?.iconCategory)
                        .to(equal(changeMessage[.iconCategory] as? String))
                    _ = manager.delete(message: changeMessage)
                })
        })
        }
    }
}
