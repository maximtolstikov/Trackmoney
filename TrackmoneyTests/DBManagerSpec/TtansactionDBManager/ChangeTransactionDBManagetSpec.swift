//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
import CoreData
import XCTest
@testable import Trackmoney

class UpdateTransactionDBManagetSpec: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .name: "testMainName",
        .icon: "iconString",
        .sum: Int32(100)]
    
    var messageAC: [MessageKeyType: Any] = [
        .name: "testCorName",
        .icon: "iconString",
        .sum: Int32(50)]
    
    var messageACtwo: [MessageKeyType: Any] = [
        .name: "twoCorName",
        .icon: "icon",
        .sum: Int32(150)]
    
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

    func testCangeIncomeTransaction() throws {
        
        try given("we have account and incom transaction", closure: {
            let resultA = managerA.create(messageAM)
            messageAM[.id] = resultA.0?.id
            messageT[.type] = TransactionType.income.rawValue
            let resultCreateTransaction = managerT.create(messageT) as! (Transaction?, DBError?)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sum] = Int32(20)
            _ = managerT.update(messageT)
        })
        try then("sum account's should equal 120", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 120)
        })
        
        messageT[.sum] = Int32(30)
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
    }
    
    func testCangeExpenseTransaction() throws {
        
        try given("we have account and expense transaction", closure: {
            let resultA = managerA.create(messageAM)
            messageAM[.id] = resultA.0?.id
            messageT[.type] = TransactionType.expense.rawValue
            let resultCreateTransaction = managerT.create(messageT) as! (Transaction?, DBError?)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sum] = Int32(20)
            _ = managerT.update(messageT)
        })
        try then("sum account's should equal 80", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 80)
        })
        
        messageT[.sum] = Int32(30)
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
    }
    
    func testCangeTransferTransaction() throws {
        
        try given("we have two accounts and transfer transaction", closure: {
            
            let resultA = managerA.create(messageAM)
            messageAM[.id] = resultA.0?.id
            let resultC = managerA.create(messageAC)
            let corAccount = resultC.0 as! Account
            messageAC[.id] = corAccount.id
            
            messageT[.type] = TransactionType.transfer.rawValue
            messageT[.corAccount] = corAccount.name
            let resultCreateTransaction = managerT.create(messageT) as! (Transaction?, DBError?)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try when("change sumTransaction on 20", closure: {
            messageT[.sum] = Int32(20)
            _ = managerT.update(messageT)
        })
        try then("sum main account's should equal 80", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAM[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 80)
        })
        try then("sum cor account's should equal 70", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAC[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let accountCor = result?.first
            XCTAssertEqual(accountCor?.sum, 70)
        })
        
        messageT[.sum] = Int32(30)
        
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
        _ = managerA.delete(messageAC[.id] as! String)        
    }
    
    func testCangeCorAccountTransaction() throws {

        try given("we have account and incom transaction", closure: {

            let resultA = managerA.create(messageAM)
            messageAM[.id] = resultA.0?.id
            let resultC = managerA.create(messageAC) as! (Account?, DBError?)
            messageAC[.id] = resultC.0?.id
            let resultCt = managerA.create(messageACtwo) as! (Account?, DBError?)
            messageACtwo[.id] = resultCt.0?.id

            messageT[.type] = TransactionType.transfer.rawValue
            messageT[.corAccount] = resultC.0?.name
            let resultCreateTransaction = managerT.create(messageT) as! (Transaction?, DBError?)
            messageT[.id] = resultCreateTransaction.0?.id
        })
        try when("change cor account", closure: {
            messageT[.corAccount] = messageACtwo[.name] as! String
            _ = managerT.update(messageT)
        })
        try then("sum cor account should equal 50", closure: {
            let predicate = NSPredicate(format: "id = %@", messageAC[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 50)
        })
        try then("sum cor account should equal 180", closure: {
            let predicate = NSPredicate(format: "id = %@", messageACtwo[.id] as! String)
            let result = managerA.get(predicate) as! [Account]?
            let account = result?.first
            XCTAssertEqual(account?.sum, 180)
        })

        messageT[.sum] = Int32(30)

        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
        _ = managerA.delete(messageAC[.id] as! String)
        _ = managerA.delete(messageACtwo[.id] as! String)
    }
}
