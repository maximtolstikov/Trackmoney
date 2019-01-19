//swiftlint:disable sorted_imports
//swiftlint:disable force_unwrapping

import XCTest
@testable import Trackmoney

class CSVSpec: XCTestCase {
    
    var csvManager: CSVManager!
    var fileManager: FileManager!
    let fileName = "Test.csv"

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
        var manager: CSVManager?
        
        try given("Array Accounts", closure: {
            manager = csvManager
        })
        try when("Run createCSV", closure: {
            url = manager?.create(with: fileName)
        })
        try then("fileCSV is exist", closure: {
            let fileExist = fileManager.fileExists(atPath: (url?.path)!)
            XCTAssert(fileExist)
        })
        try then("file isn't empty", closure: {
            let text = try? String(contentsOf: url!)
//            print(text)
            XCTAssertNotEqual(text, "")
        })
        
    }
    
    func testLoad() throws {
        
        var url: URL?
        var quantityEntity = 0
        
        try given("quantity entity", closure: {
            quantityEntity = getQuantityEntities()
            let path = try fileManager.url(for: .documentDirectory,
                                           in: .allDomainsMask,
                                           appropriateFor: nil,
                                           create: false)
            let fileURL = path.appendingPathComponent(fileName)
            url = fileURL
            let fileExist = fileManager.fileExists(atPath: (url?.path)!)
            XCTAssert(fileExist)
        })
//        try when("remove all entity from dataBase", closure: {
//            csvManager.cleanDataBase()
//            let count = getQuantityEntities()
//            XCTAssertEqual(count, 0)
//        })
//        try then("file is exist", closure: {
//            let path = try fileManager.url(for: .documentDirectory,
//                                           in: .allDomainsMask,
//                                           appropriateFor: nil,
//                                           create: false)
//            let fileURL = path.appendingPathComponent(fileName)
//            url = fileURL
//            let fileExist = fileManager.fileExists(atPath: (url?.path)!)
//            XCTAssert(fileExist)
//        })
        try when("restor data, quantity entiry again", closure: {
            csvManager.restorFrom(file: fileName)
            let count = getQuantityEntities()
            XCTAssertEqual(count, quantityEntity)
        })
        
        try then("delete testFile", closure: {
            try? fileManager.removeItem(at: url!)
            XCTAssertFalse(fileManager.fileExists(atPath: (url?.path)!))
        })
    }
    
    private func getQuantityEntities() -> Int {
        let predicate = NSPredicate(value: true)
        guard let accounts = AccountDBManager().get(predicate) as? [Account],
            let categories = CategoryDBManager().get(predicate) as? [CategoryTransaction],
            let tratsactions = TransactionDBManager().get(predicate) as? [Transaction] else { return 0 }
        return accounts.count + categories.count + tratsactions.count
    }

}
