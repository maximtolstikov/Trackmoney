//swiftlint:disable sorted_imports

import XCTest
@testable import Trackmoney

class CSVSpec: XCTestCase {
    
    var csvManager: CSVManager!
    var fileManager: FileManager!

    override func setUp() {
        csvManager = CSVManager()
        fileManager = FileManager.default
    }

    override func tearDown() {
        csvManager = nil
        fileManager = nil
    }

    func testCreate() throws {
        
        var url: URL?
        
        try given("Array Accounts", closure: {

        })
        try when("Run createCSV", closure: {
            url = csvManager.create(with: "Test.csv")
        })
        try then("fileCSV is exist", closure: {
            var fileExist = fileManager.fileExists(atPath: (url?.path)!)
            XCTAssert(fileExist)
        })
        try then("file isn't empty", closure: {
            let text = try? String(contentsOf: url!)
            print(text)
            XCTAssertNotEqual(text, "")
        })
        try then("delete testFile", closure: {
            try? fileManager.removeItem(at: url!)
            XCTAssertFalse(fileManager.fileExists(atPath: (url?.path)!))
        })
    }

}
