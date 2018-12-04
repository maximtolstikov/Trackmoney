import CoreData

class ToolsDataProvider: ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol?
    var dateManager: SupplierDates?
    weak var controller: ToolsController?
    var currentDate: Date?
    
    func load(_ period: Period) {
        
        dateManager?.current(period, completion: { (startDate, finishDate) in
            
            guard let start = startDate, let finish = finishDate else {
                assertionFailure()
                return
            }
            
            self.currentDate = start
            
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        start as NSDate,
                                        finish as NSDate)
            
            let result = self.dataManager?.get(predicate)
            
            let objects = result?.0
            
            print(objects?.count)
        })
    }
    
    func next(_ period: Period) {
        
        guard let date = currentDate else { return }
        
        dateManager?.next(period, date, completion: { (startDate, finishDate) in
            
            guard let start = startDate, let finish = finishDate else {
                assertionFailure()
                return
            }
            
            self.currentDate = start
            
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        start as NSDate,
                                        finish as NSDate)
            
            let result = self.dataManager?.get(predicate)
            
            let objects = result?.0
            
            print(objects?.count)
        })
    }
    
    func previous(_ period: Period) {
        
        guard let date = currentDate else { return }
        
        dateManager?.previous(period, date, completion: { (startDate, finishDate) in
            
            guard let start = startDate, let finish = finishDate else {
                assertionFailure()
                return
            }
            
            self.currentDate = start
            
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        start as NSDate,
                                        finish as NSDate)
            
            let result = self.dataManager?.get(predicate)
            
            let objects = result?.0
            
            print(objects?.count)
        })
    }
    
    func loadFor(month: Int, year: Int) {
        
    }
    
}
