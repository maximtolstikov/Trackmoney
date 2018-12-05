import Foundation

class DateManager: SupplierDates {
    
    let calendar = Calendar.current
    var components = DateComponents()
    
    var startDate: Date?
    var finishDate: Date?
    
    var month = 0
    var year = 0
    
    func dates(_ period: Period,
               _ what: WhatPeriod,
               _ date: Date,
               completion: @escaping (Date?, Date?) -> Void) {
        
        setCurrentComponentsBy(date)
        
        switch what {
            
        case .current:
            setCurrentDates(period)
        case .next:
            setNextDates(period)
        case .previous:
            setPreviousDates(period)
        }
        completion(startDate, finishDate)
    }
    
    private func setCurrentDates(_ period: Period) {
        
        switch period {
        case .month:
            startDate = calendar.date(from: components)
            increaseMonth(&month, &year)
            finishDate = calendar.date(from: components)
        case .year:
            components.month = 1
            startDate = calendar.date(from: components)
            components.year = year + 1
            finishDate = calendar.date(from: components)
        }
    }
    
    private func setNextDates(_ period: Period) {
        
        switch period {
        case .month:
            increaseMonth(&month, &year)
            startDate = calendar.date(from: components)
            increaseMonth(&month, &year)
            finishDate = calendar.date(from: components)
        case .year:
            year += 1
            components.year = year
            startDate = calendar.date(from: components)
            components.year = year + 1
            finishDate = calendar.date(from: components)
        }
    }
    
    private func setPreviousDates(_ period: Period) {
        
        switch period {
        case .month:
            finishDate = calendar.date(from: components)
            decreaseMoth(&month, &year)
            startDate = calendar.date(from: components)
        case .year:
            year -= 1
            components.year = year
            startDate = calendar.date(from: components)
            components.year = year + 1
            finishDate = calendar.date(from: components)
        }
    }
    
    private func setCurrentComponentsBy(_ date: Date) {
        
        let currentDateComponets = currentDateComponents(date)
        
        guard let monthComponent = currentDateComponets.month,
            let yearComponent = currentDateComponets.year else {
                assertionFailure()
                return
        }
        
        month = monthComponent
        year = yearComponent
        
        components.year = year
        components.month = month
        components.day = 1
    }
    
    private func currentDateComponents(_ date: Date) -> DateComponents {
        return calendar.dateComponents([.month, .year], from: date)
    }
    
    private func increaseMonth(_ month: inout Int, _ year: inout Int) {
        
        month += 1
        
        if month > 12 {
            month = 1
            year += 1
        }
        components.year = year
        components.month = month
    }
    
    private func decreaseMoth(_ month: inout Int, _ year: inout Int) {
        
        month -= 1
        
        if month < 1 {
            month = 12
            year -= 1
        }
        components.year = year
        components.month = month
    }
 
}
