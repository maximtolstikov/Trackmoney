/// Описывает интерфейс поставщика данных для контроллера Tools
protocol ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol? { get }
    var dateManager: SupplierDates? { get }
    
    func loadData(_ what: WhatPeriod, _ period: Period)
    func loadDateFor(month: Int, year: Int)
}
