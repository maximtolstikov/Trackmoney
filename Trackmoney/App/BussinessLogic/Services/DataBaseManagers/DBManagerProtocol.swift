// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(message: [MessageKeyType: Any]) -> Bool
    func get() -> [NSManagedObject]?
    func change(message: [MessageKeyType: Any]) -> Bool
    func delete(message: [MessageKeyType: Any]) -> Bool
    
}
