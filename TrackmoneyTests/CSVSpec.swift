//swiftlint:disable sorted_imports
//swiftlint:disable force_unwrapping
import XCTest
@testable import Trackmoney

class CSVSpec: XCTestCase {
    
    var csvManager: CSVManager!
    var fileManager: FileManager!

    override func setUp() {
        super.setUp()
        fileManager = FileManager.default
    }

    override func tearDown() {
        csvManager = nil
        fileManager = nil
        super.tearDown()
    }
    
    func testArchive() throws {
        
        var nameArchives: String?
    
        try given("csvManager", closure: {
            csvManager = CSVManagerImpl()
        })
        try when("run rrete archive", closure: {
            csvManager.create(completionHandler: { (name) in
                nameArchives = name
            })
        })
        try then("nameArchive is not nil", closure: {
            XCTAssertNotNil(nameArchives)
        })
    }
    
    func getArchives() throws {
        
        var archivesList = [String]()
        
        try given("csvManager", closure: {
            csvManager = CSVManagerImpl()
        })
        try when("get archives list", closure: {
            csvManager.archivesList(completionHandler: { (list) in
                archivesList = list!
            })
        })
        try then("archives list is not empty", closure: {
            XCTAssertFalse(archivesList.isEmpty)
        })
    }
    
    func testRestore() throws {
        
        var archivesList = [String]()
        var result = false
        
        try given("archives list", closure: {
            csvManager = CSVManagerImpl()
            csvManager.archivesList(completionHandler: { (list) in
                archivesList = list!
            })
        })
        try when("run restore", closure: {
            csvManager.restorFrom(file: archivesList.last!, completionHandler: { (flag) in
                result = flag
            })
        })
        try then("", closure: {
            XCTAssertTrue(result)
        })
    }

}
