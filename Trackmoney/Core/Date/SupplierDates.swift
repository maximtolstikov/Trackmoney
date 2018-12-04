import Foundation

/// Определяет интрефейс поставщика Дат
protocol SupplierDates {
    
    /// Вычсляет даты начала и окончания заданного периода
    func dates(_ period: Period,
               _ what: WhatPeriod,
               _ date: Date,
               completion: @escaping (Date?, Date?) -> Void)

    
}
