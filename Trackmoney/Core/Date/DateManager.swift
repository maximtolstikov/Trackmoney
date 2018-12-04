import Foundation

class DateManager: SupplierDates {    
    
    let calendar = Calendar.current
    
    var month: Int = 0
    var year: Int = 0
    
    var startDate: Date?
    var finishDate: Date?
    
    init?() {
        
        var dateComponentsNow: DateComponents {
            
            let currentDate = Date()
            return calendar.dateComponents([.month, .year], from: currentDate)
        }
        
        guard let monthComponents = dateComponentsNow.month,
            let yearComponents = dateComponentsNow.year else {
                assertionFailure()
                return nil
        }
        
        self.month = monthComponents
        self.year = yearComponents
    }
    
    func datesFor(_ period: Period, _ whatPeriod: WhatPeriod,
                  completion: @escaping (Date?, Date?) -> Void) {
        
        print("period: \(period), what: \(whatPeriod), month: \(month), year: \(year)")
        
        guard month > 0 && month < 13 else { return }
        
        if period == .month {
            
            switch whatPeriod {
            case .current:
                startDate = calendar.date(from: dateComponents(.month))
                increaseMonth(&month, &year)
                finishDate = calendar.date(from: dateComponents(.month))
            case .next:
                startDate = finishDate
                increaseMonth(&month, &year)
                finishDate = calendar.date(from: dateComponents(.month))
            case .previous:
                finishDate = startDate
                decreaseMoth(&month, &year)
                startDate = calendar.date(from: dateComponents(.month))
            }
        } else {
            
            switch whatPeriod {
            case .current:
                startDate = calendar.date(from: dateComponents(.year))
                year += 1
                finishDate = calendar.date(from: dateComponents(.year))
            case .next:
                startDate = finishDate
                year += 1
                finishDate = calendar.date(from: dateComponents(.year))
            case .previous:
                finishDate = startDate
                year -= 1
                startDate = calendar.date(from: dateComponents(.year))
            }
        }
        completion(startDate, finishDate)
    }
    
    func datePickerDates(month: Int,
                         year: Int,
                         completion: @escaping (Date?, Date?) -> Void) {
        
    }
    
    private func dateComponents(_ period: Period) -> DateComponents {
        
        var dateComponents = DateComponents()
        
        switch period {
        case .month:
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1
        case .year:
            dateComponents.year = year
            dateComponents.month = 1
            dateComponents.day = 1
        }
        return dateComponents
    }
    
    private func increaseMonth(_ month: inout Int, _ year: inout Int) {
        
        month += 1
        
        if month > 12 {            
            month = 1
            year += 1
        }
    }
    
    private func decreaseMoth(_ month: inout Int, _ year: inout Int) {
        
        month -= 1
        
        if month < 0 {
            month = 12
            year -= 1
        }
    }
    
}
