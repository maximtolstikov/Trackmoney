import CoreData

class ToolsDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: ToolsController?
    
    func loadData() {
        
//        let calendar = Calendar.current
//        
//        var dateComponents = DateComponents()
//        dateComponents.year = 2018
//        dateComponents.month = 11
//        
//        let date = calendar.date(from: dateComponents) as! NSDate
//        
//        let predicate = NSPredicate(format: "date", date)
//        
//        let result = dbManager?.get()
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func delete(with id: String) -> Bool {
        return false
    }
    
}
