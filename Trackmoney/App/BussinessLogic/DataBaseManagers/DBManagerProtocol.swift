// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, DBError?)
    func get(_ predicate: NSPredicate) -> [DBEntity]?
    func update(_ message: [MessageKeyType: Any]) -> DBError?
    func delete(_ id: String) -> DBError?
    
}
