import CoreData

class ToolsDataProvider: ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol?
    var dateManager: SupplierDates?
    weak var controller: ToolsController?
    
    func loadData(_ what: WhatPeriod, _ period: Period) {
        
        dateManager?.datesFor(period, what, completion: { (startDate, finishDate) in
            
            guard let start = startDate, let finish = finishDate else {
                assertionFailure()
                return
            }
            
            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        start as NSDate,
                                        finish as NSDate)
            
            let result = self.dataManager?.get(predicate)
            
            let objects = result?.0
            
            print(objects?.count)
            //print("period: \(period), what: \(what)")
        })
    }
    
    func loadDateFor(month: Int, year: Int) {
        
    }
    
    
    
    
    func loadData() {
        
        //        dateManager?.monthDates(.current, completion: { (startDate, finishDate) in
        //
        //            guard let start = startDate, let finish = finishDate else {
        //                assertionFailure()
        //                return
        //            }
        //
        //            let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", start as! NSDate, finish as! NSDate)
        //
        //            let result = self.dbManager?.get(predicate)
        //
        //            let objects = result?.0
        //
        //            print(objects?.count)
        //        })
        
    }
    
}
