import Foundation

/// Определяет интрефейс поставщика Дат
protocol SupplierDates {
    
    /// Вычсляет даты начала и окончания периода
    func datesFor(_ period: Period, _ whatPeriod: WhatPeriod,
                  completion: @escaping (Date?, Date?) -> Void)
    
    /// Вычсляет даты начала и окончания периода заданного UIDatePicker
    func datePickerDates(month: Int,
                         year: Int,
                         completion: @escaping (Date?, Date?) -> Void)
}
