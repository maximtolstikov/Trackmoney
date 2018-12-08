import Foundation

/// Описывает интерфейс поставщика данных для контроллера Tools
protocol ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol? { get }
    var dateManager: SupplierDates? { get }
    
    func load(_ period: Period, _ what: WhatPeriod)
}
