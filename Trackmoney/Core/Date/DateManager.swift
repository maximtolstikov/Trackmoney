import Foundation

class DateManager: SupplierDates {
    
    let calendar = Calendar.current
    var components = DateComponents()
    var startDate: Date?
    var finishDate: Date?
    
    var month = 0
    var year = 0
    
    func current(_ period: Period, completion: @escaping (Date?, Date?) -> Void) {
        
        let dateNow = Date()
        setCurrentComponentsBy(dateNow)

        switch period {
        case .month:
            components.year = year
            components.month = month
            components.day = 1
            startDate = calendar.date(from: components)
            increaseMonth(&month, &year)

            finishDate = calendar.date(from: components)
        case .year:
            break
        }
        completion(startDate, finishDate)
    }
    
    func next(_ period: Period,
              _ date: Date,
              completion: @escaping (Date?, Date?) -> Void) {
        
        switch period {
        case .month:
            setCurrentComponentsBy(date)
            increaseMonth(&month, &year)
            startDate = calendar.date(from: components)
            increaseMonth(&month, &year)
            finishDate = calendar.date(from: components)
        case .year:
            break
        }
        completion(startDate, finishDate)
    }
    
    func previous(_ period: Period,
                  _ date: Date,
                  completion: @escaping (Date?, Date?) -> Void) {
        
        switch period {
        case .month:
            setCurrentComponentsBy(date)
            finishDate = calendar.date(from: components)
            decreaseMoth(&month, &year)
            startDate = calendar.date(from: components)
        case .year:
            break
        }
        completion(startDate, finishDate)
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
        
        if month < 0 {
            month = 12
            year -= 1
        }
        components.year = year
        components.month = month
    }
    
//    var month: Int = 0
//    var year: Int = 0
//
//    var startDate: Date?
//    var finishDate: Date?
//
//    init?() {
//
//        var dateComponentsNow: DateComponents {
//
//            let currentDate = Date()
//            return calendar.dateComponents([.month, .year], from: currentDate)
//        }
//
//        guard let monthComponents = dateComponentsNow.month,
//            let yearComponents = dateComponentsNow.year else {
//                assertionFailure()
//                return nil
//        }
//
//        self.month = monthComponents
//        self.year = yearComponents
//    }
//
//    func datesFor(_ period: Period, _ whatPeriod: WhatPeriod,
//                  completion: @escaping (Date?, Date?) -> Void) {
//
//        print("period: \(period), what: \(whatPeriod), month: \(month), year: \(year)")
//
//        guard month > 0 && month < 13 else { return }
//
//        if period == .month {
//
//            switch whatPeriod {
//            case .current:
//                startDate = calendar.date(from: dateComponents(.month))
//                increaseMonth(&month, &year)
//                finishDate = calendar.date(from: dateComponents(.month))
//            case .next:
//                startDate = finishDate
//                increaseMonth(&month, &year)
//                finishDate = calendar.date(from: dateComponents(.month))
//            case .previous:
//                finishDate = startDate
//                decreaseMoth(&month, &year)
//                startDate = calendar.date(from: dateComponents(.month))
//            }
//        } else {
//
//            switch whatPeriod {
//            case .current:
//                startDate = calendar.date(from: dateComponents(.year))
//                year += 1
//                finishDate = calendar.date(from: dateComponents(.year))
//            case .next:
//                startDate = finishDate
//                year += 1
//                finishDate = calendar.date(from: dateComponents(.year))
//            case .previous:
//                finishDate = startDate
//                year -= 1
//                startDate = calendar.date(from: dateComponents(.year))
//            }
//        }
//        completion(startDate, finishDate)
//    }
//
//    func datePickerDates(month: Int,
//                         year: Int,
//                         completion: @escaping (Date?, Date?) -> Void) {
//
//    }
//
//    private func dateComponents(_ period: Period) -> DateComponents {
//
//        var dateComponents = DateComponents()
//
//        switch period {
//        case .month:
//            dateComponents.year = year
//            dateComponents.month = month
//            dateComponents.day = 1
//        case .year:
//            dateComponents.year = year
//            dateComponents.month = 1
//            dateComponents.day = 1
//        }
//        return dateComponents
//    }
//

    
}
