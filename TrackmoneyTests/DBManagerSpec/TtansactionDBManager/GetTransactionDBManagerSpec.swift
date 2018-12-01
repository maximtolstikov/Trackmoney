//swiftlint:disable sorted_imports
//swiftlint:disable force_cast
import CoreData
import XCTest
@testable import Trackmoney

class GetTransactionDBManager: XCTestCase {
    
    var messageAM: [MessageKeyType: Any] = [
        .name: "testMainName",
        .icon: "iconString",
        .sum: Int32(100)]
    
    var messageT: [MessageKeyType: Any] = [
        .sum: Int32(30),
        .mainAccount: "testMainName",
        .icon: "iconString"]
    
    var managerA: AccountDBManager!
    var managerT: TransactionDBManager!
    
    override func setUp() {
        
        managerA = AccountDBManager()
        managerT = TransactionDBManager()
        
        let resultCreateMainAccount = managerA.create(messageAM)
        messageAM[.id] = resultCreateMainAccount.0?.id
        
        messageT[.type] = TransactionType.income.rawValue
        let result = managerT.create(messageT) as! (Transaction?, ErrorMessage?)
        messageT[.id] = result.0?.id
        messageT[.date] = result.0?.date
    }
    
    override func tearDown() {
        _ = managerT.delete(messageT[.id] as! String)
        _ = managerA.delete(messageAM[.id] as! String)
        managerA = nil
        managerT = nil
    }

    func testGetByDate() throws {
        
        var transaction: Transaction?
        
        try when("get transaction", closure: {
            let predicate = NSPredicate(format: "date = %@", messageT[.date] as! NSDate)
            let result = managerT.get(predicate)  as! ([Transaction]?, ErrorMessage?)
            transaction = result.0?.first
        })
        try then("result is not nil", closure: {
            XCTAssertNotNil(transaction)
        })
        
    }
}
