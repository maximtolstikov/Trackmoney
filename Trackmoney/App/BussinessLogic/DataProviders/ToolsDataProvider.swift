//swiftlint:disable force_cast
import CoreData

class ToolsDataProvider: ToolsDataProviderProtocol {
   
    var dataManager: DBManagerProtocol?
    var dateManager: SupplierDates?
    weak var controller: ToolsController?
    var currentDate: Date?

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
            
            let byDates = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        start as NSDate,
                                        finish as NSDate)
            
            let resultByDates = self.dataManager?.get(byDates)
            
            let manager = CategoryDBManager()
            let all = NSPredicate(value: true)
            let resultAll = manager.get(all)
            
            guard let objectsTransaction = resultByDates,
                !objectsTransaction.isEmpty,
                let objectsCategory = resultAll else {
                return
            }
            
            let transactions = objectsTransaction as! [Transaction]
            let categories = objectsCategory as! [CategoryTransaction]

            self.currentDate = start
            self.setTitle(start, period)
            
            DispatchQueue.global().async {
                
                let expenseTransaction = transactions
                    .filter { $0.type == TransactionType.expense.rawValue }
                let incomeTransaction = transactions
                    .filter { $0.type == TransactionType.income.rawValue }
                
                var calculator = AverageValues(categories)
                let expenseAverageCategories = calculator
                    .collectCategories(expenseTransaction)
                let incomeAverageCategories = calculator
                    .collectCategories(incomeTransaction)
                
                self.controller?.expenseCategories = expenseAverageCategories
                self.controller?.incomeCategories = incomeAverageCategories
            }
        })
    }
    
    private func setTitle(_ from: Date, _ period: Period) {
        
        let dateFormatter = DateFormatter()
        
        switch period {
        case .month:
            dateFormatter.dateFormat = "MMMM"
        case .year:
            dateFormatter.dateFormat = "y"
        }
        
        let title = dateFormatter.string(from: from)
        self.controller?.navigationItem.title = title
    }
    
}
