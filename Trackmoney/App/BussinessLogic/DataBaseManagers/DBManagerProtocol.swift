// Для описания интерфейса менеджеров базы данных

import CoreData

protocol DBManagerProtocol {
        
    func create(_ message: Message) -> (DBEntity?, DBError?)
    func get(_ predicate: NSPredicate) -> [DBEntity]?
    func update(_ message: Message) -> DBError?
    func delete(_ id: String, force: Bool) -> DBError?
    
}
