// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?)
    func get() -> [NSManagedObject]?
    func change(message: [MessageKeyType: Any]) -> ErrorMessage?
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage?
    
}
