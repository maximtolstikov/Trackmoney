//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
import CoreData
import XCTest
@testable import Trackmoney

class DeleteTransactionDBManagetSpec: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .name: "testMainName",
        .icon: "iconString",
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
    
    func testDeleteIncomeTransaction() throws {
        
        var accountMain: Account!
        
        try given("account and after transaction income sum equal 130", closure: {
            let resultCreateMainAccount = managerA.create(messageAM)
            messageAM[.id] = resultCreateMainAccount.0?.id
            messageT[.type] = TransactionType.income.rawValue
            let resultCreateTransaction = managerT.create(messageT)
            messageT[.id] = resultCreateTransaction.0?.id
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            accountMain = result?.first
            XCTAssertEqual(accountMain?.sum, 130)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(messageT[.id] as! String, force: false)
        })
        try then("sum Account equal 100 again", closure: {
            XCTAssertEqual(accountMain.sum, 100)
        })
        
        _ = managerA.delete(messageAM[.id] as! String, force: false)
        
    }
    
    func testDeleteExpenseTransaction() throws {
        
        var accountMain: Account!
        
        try given("account and after transaction income sum equal 70", closure: {
            let resultCreateMainAccount = managerA.create(messageAM)
            messageAM[.id] = resultCreateMainAccount.0?.id
            messageT[.type] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(messageT)
            messageT[.id] = resultCreateTransaction.0?.id
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            accountMain = result?.first
            XCTAssertEqual(accountMain?.sum, 70)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(messageT[.id] as! String, force: false)
        })
        try then("sum Account equal 100 again", closure: {
            XCTAssertEqual(accountMain.sum, 100)
        })
        
        _ = managerA.delete(messageAM[.id] as! String, force: false)
        
    }
    
    func testTranserIncomeTransaction() throws {
        
        var accountMain: Account!
        var accountCor: Account!
        
        try given("two accounts, aftertransfer sumM equal 70, sumC 80 ", closure: {
            let resultCreateMainAccount = managerA.create(messageAM)
            messageAM[.id] = resultCreateMainAccount.0?.id
            let resultCreateCorAccount = managerA.create(messageAC)
            messageAC[.id] = resultCreateCorAccount.0?.id
            
            let predicateM = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let resultM = managerA.get(predicateM) as! [Account]?
            accountMain = resultM?.first
            
            let predicateC = NSPredicate(format: "id = %@", messageAC[.id] as! String)
            let resultC = managerA.get(predicateC) as! [Account]?
            accountCor = resultC?.first
            
            messageT[.type] = TransactionType.transfer.rawValue
            messageT[.corAccount] = accountCor.name
            let resultCreateTransaction = managerT.create(messageT)
            messageT[.id] = resultCreateTransaction.0?.id
            
            XCTAssertEqual(accountMain?.sum, 70)
            XCTAssertEqual(accountCor?.sum, 80)
        })
        try when("delete transaction", closure: {
            _ = managerT.delete(messageT[.id] as! String, force: false)
        })
        try then("sum AccountMain equal 100 and sum Cor 50 again", closure: {
            XCTAssertEqual(accountMain.sum, 100)
            XCTAssertEqual(accountCor.sum, 50)
        })
        
        _ = managerA.delete(messageAM[.id] as! String, force: false)
        _ = managerA.delete(messageAC[.id] as! String, force: false)
        
    }
    
}
