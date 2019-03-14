//swiftlint:disable force_cast
import CoreData
import UIKit

class AccountsDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: AccountsController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result else {
            assertionFailure()
            return
        }
        
        let accounts = objects as! [Account]
       
        let totalSum = accounts.map { $0.sum }.reduce (0, +)
        controller?.navigationItem.title = "Total: " + " " + "\(totalSum)"
        controller?.accounts = accounts
    }
    
    func save(message: Message, completion: @escaping Result) {}
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {}
    
}
