import Foundation

/// Определяет интрефейс поставщика Дат
protocol SupplierDates {
    
    /// Вычсляет даты начала и окончания текущего периода
    func current(_ period: Period, completion: @escaping (Date?, Date?) -> Void)
    
    /// Вычсляет даты начала и окончания следующего периода
    func next(_ period: Period,
              _ date: Date,
              completion: @escaping (Date?, Date?) -> Void)
    
    /// Вычсляет даты начала и окончания предшествующего периода
    func previous(_ period: Period,
                  _ date: Date,
                  completion: @escaping (Date?, Date?) -> Void)
    
}
