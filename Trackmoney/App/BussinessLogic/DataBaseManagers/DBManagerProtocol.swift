// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, ErrorMessage?)
    func get(_ predicate: NSPredicate) -> ([DBEntity]?, ErrorMessage?)
    func update(_ message: [MessageKeyType: Any]) -> ErrorMessage?
    func delete(_ id: String) -> ErrorMessage?
    
}
