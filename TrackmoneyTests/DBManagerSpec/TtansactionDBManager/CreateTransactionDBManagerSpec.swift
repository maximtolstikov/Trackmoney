//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping
import CoreData
import XCTest
@testable import Trackmoney

class CreateTransactionDBManagerSpec: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .name: "testMainName",
        .icon: "icon",
        .sum: Int32(100)]
    var messageAC: [MessageKeyType: Any] = [
        .name: "testCorName",
        .icon: "iconString",
        .sum: Int32(50)]
    var messageT: [MessageKeyType: Any] = [
        .sum: Int32(30),
        .mainAccount: "testMainName",
        .icon: "iconString"]
    
    var managerA: AccountDBManager!
    var managerT: TransactionDBManager!
    
    override func setUp() {
        managerA = AccountDBManager()
        managerT = TransactionDBManager()
    }
    override func tearDown() {
        managerA = nil
        managerT = nil
    }

    func testCreateIncomeTransaction() throws {
        
        var resultCreateTransaction: (Transaction?, DBError?)
        
        try given("account", closure: {
            let result = managerA.create(messageAM)
            messageAM[.id] = result.0?.id
        })
        try when("create incom transaction", closure: {
            messageT[.type] = TransactionType.income.rawValue
            messageT[.note] = "test note"
            messageT[.category] = "myCategory"
            resultCreateTransaction = managerT.create(messageT) as! (Transaction?, DBError?)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try then("result error is not nil", closure: {
            let predicate = NSPredicate(format: "id = %@", messageT[.id] as! String)
            let result = managerT.get(predicate) as! [Transaction]?
            let object = result?.first
            XCTAssertNotNil(object)
        })
        try then("transaction.category equal myCategory", closure: {
            let predicate = NSPredicate(format: "id = %@", messageT[.id] as! String)
            let result = managerT.get(predicate) as! [Transaction]?
            let transaction = result?.first
            XCTAssertEqual(transaction?.category, "myCategory")
        })
        try then("accountMainSum equal 130", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 130)
        })
        try then("note equal 'test note'", closure: {
            let id = resultCreateTransaction.0?.id
            let predicate = NSPredicate(format: "id = %@", id!)
            let result = managerT.get(predicate) as! [Transaction]?
            let transaction = result?.first
            let note = transaction?.note
            XCTAssertEqual(note, "test note")
        })
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
    }
    
    func testCreateExpenseTransaction() throws {
        
        try given("account", closure: {
            let result = managerA.create(messageAM)
            messageAM[.id] = result.0?.id
        })
        try when("create incom transaction", closure: {
            messageT[.type] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(messageT)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try then("resultGetTransaction is not nil", closure: {
            let predicate = NSPredicate(format: "id = %@", messageT[.id] as! String)
            let result = managerT.get(predicate) as! [Transaction]?
            XCTAssertFalse((result?.isEmpty)!)
        })
        try then("accountMainSum equal 70", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 70)
        })
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
    }
    
    func testCreateTransferTransaction() throws {
        
        try given("two accounts", closure: {
            let resultCreateMainAccount = managerA.create(messageAM)
            messageAM[.id] = resultCreateMainAccount.0?.id
            let resultCreateCorAccount = managerA.create(messageAC)
            messageAC[.id] = resultCreateCorAccount.0?.id
            XCTAssertNotNil(resultCreateCorAccount)
        })
        try when("create incom transaction", closure: {
            messageT[.type] = TransactionType.transfer.rawValue
            messageT[.corAccount] = "testCorName"
            let result = managerT.create(messageT)
            messageT[.id] = result.0?.id
        })
        try then("object is not nil", closure: {
            let predicate = NSPredicate(format: "id = %@", messageT[.id] as! String)
            let result = managerT.get(predicate) as! [Transaction]?
            let transaction = result?.first
            XCTAssertNotNil(transaction)
        })
        try then("accountMainSum equal 70", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 70)
        })
        try then("accountCorSum equal 80", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAC[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 80)
        })
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
        _ = managerA.delete(messageAC[.id] as! String)
    }
    
}
