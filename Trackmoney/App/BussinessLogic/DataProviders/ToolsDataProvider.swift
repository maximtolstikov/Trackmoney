import CoreData

class ToolsDataProvider: ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol?
    var dateManager: SupplierDates?
    weak var controller: ToolsController?
    var currentDate: Date?
    
    // TODO: - сделать проверку если данные не найдены то сurrentDate не обновлять
    
    func load(_ period: Period, _ what: WhatPeriod) {
        
        if what == .current {
            currentDate = Date()
        }
        
        guard let date = currentDate else { return }
        
        dateManager?.dates(period, what, date, completion: { (startDate, finishDate) in
            
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
