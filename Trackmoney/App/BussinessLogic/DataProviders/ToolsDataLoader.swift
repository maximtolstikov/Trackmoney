//Для описания ДатаПровайдера для контроллера Инструменты

import CoreData

class ToolsDataLoader: DataProviderProtocol {

    var dbManager: DBManagerProtocol?
    weak var controller: ToolsController?
    
    func loadData() {
        
        // let transaction = dbManager?.get()
        // TODO: сдесь обрабатываем полученные данные и выводим их на контроллер
        
    }
    
    func save(message: [MessageKeyType: Any]) {}
    
    func delete(with id: NSManagedObjectID) -> Bool {
        return false
    }
    
}
