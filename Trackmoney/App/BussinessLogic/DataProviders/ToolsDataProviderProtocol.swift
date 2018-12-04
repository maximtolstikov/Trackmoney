/// Описывает интерфейс поставщика данных для контроллера Tools
protocol ToolsDataProviderProtocol {
    
    var dataManager: DBManagerProtocol? { get }
    var dateManager: SupplierDates? { get }
    
    func load(_ period: Period)
    func next(_ period: Period)
    func previous(_ period: Period)
    func loadFor(month: Int, year: Int)
}
