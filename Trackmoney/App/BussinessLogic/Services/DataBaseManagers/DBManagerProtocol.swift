// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(message: [MessageKeyType: Any]) -> Bool
    func getAllObject() -> [NSManagedObject]?
    func getOneObject(message: [MessageKeyType: Any]) -> NSManagedObject?
    func change(message: [MessageKeyType: Any]) -> Bool
    func delete(message: [MessageKeyType: Any]) -> Bool
    
}
