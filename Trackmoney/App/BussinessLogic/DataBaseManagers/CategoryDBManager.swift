//swiftlint:disable force_cast
import CoreData
import UIKit

class CategoryDBManager: DBManager, DBManagerProtocol {
    
    lazy var transactionDBManager = TransactionDBManager()
    
    func create(_ message: [MessageKeyType: Any]) -> (DBEntity?, ErrorMessage?) {
        
        // Проверка что объекта с таким именем нет в базе
        guard let name = message[.name] else {
            return (nil, ErrorMessage(error: .messageHaventRequireValue))
        }
        
        let predicateName = NSPredicate(format: "name = %@", name as! String)
        let resultForName = get(predicateName)
        
        guard resultForName.1 == nil else {
            return (nil, resultForName.1)
        }
        //swiftlint:disable next force_unwrapping
        guard (resultForName.0?.isEmpty)! else {
            return (nil, ErrorMessage(error: .objectIsExistAlready))
        }
        
        // Создание нового объекта
        let category = CategoryTransaction(context: context)
        
        category.id = UUID().uuidString
        category.name = message[.name] as! String
        category.icon = message[.icon] as! String
        category.type = message[.type] as! String
        
        if let parentName = message[.parent] {
            let predicate = NSPredicate(format: "name = %@", parentName as! String)
            let result = get(predicate) as! ([CategoryTransaction]?, ErrorMessage?)
            
            guard let parent = result.0?.first else {
                return (nil, ErrorMessage(error: .objectIsNotExist))
            }
            
            category.parent = parent
            parent.addToChild(category)
        }
        
        do {
            try context.save()
            return (category, nil)
            
        } catch {
            print(error.localizedDescription)
            return (nil, ErrorMessage(error: .contextDoNotBeSaved))
        }
    }
    
    func get(_ predicate: NSPredicate) -> ([DBEntity]?, ErrorMessage?) {
        
        let fetchRequest: NSFetchRequest<CategoryTransaction> = CategoryTransaction.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return (result, nil)
            
        } catch {
            return (nil, ErrorMessage(error: .objectCanntGetFromBase))
        }
    }
    
    func update(_ message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
        let result = get(predicate) as! ([CategoryTransaction]?, ErrorMessage?)
        
        if let error = result.1 {
            return error
        }
        
        guard let category = result.0?.first else {
            return ErrorMessage(error: .objectIsNotExist)
        }
        
        if let parent = message[.parent] {
            
            if let oldParentName = category.parent?.name {
                
                let predicate = NSPredicate(format: "name = %@", oldParentName)
                let result = get(predicate) as! ([CategoryTransaction]?, ErrorMessage?)
                
                guard let oldParent = result.0?.first else {
                    return ErrorMessage(error: .objectIsNotExist)
                }
                
                oldParent.removeFromChild(category)
            }
            
            let predicate = NSPredicate(format: "name = %@", parent as! String)
            let result = get(predicate) as! ([CategoryTransaction]?, ErrorMessage?)
            
            guard let newParent = result.0?.first else {
                return ErrorMessage(error: .objectIsNotExist)
            }
            
            category.parent = newParent
            newParent.addToChild(category)
        }
        
        if mManager.isExistValue(for: .name, in: message) {
            
            let newName = message[.name] as! String
            
            let predicate = NSPredicate(format: "category = %@", category.name)
            let result = transactionDBManager.get(predicate)
            
            guard let objects = result.0 else {
                return ErrorMessage(error: .objectCanntGetFromBase)
            }

            let transactions = objects as! [Transaction]
            _ = transactions.map { $0.category = newName }
            
            category.name = newName
        }
        
        if mManager.isExistValue(for: .icon, in: message) {
            category.icon = message[.icon] as! String
        }
        
        return saveContext()
    }
    
    func delete(_ id: String) -> ErrorMessage? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate) as! ([CategoryTransaction]?, ErrorMessage?)
        
        if let error = result.1 {
            return error
        }
        
        guard let object = result.0?.first else {
            return ErrorMessage(error: .objectIsNotExist)
        }
        
        context.delete(object)
        
        return saveContext()
    }
    
    // Сохраняет контекст
    private func saveContext() -> ErrorMessage? {
        
        do {
            try context.save()
            return nil
        } catch {
            print(error.localizedDescription)
            return ErrorMessage(error: .contextDoNotBeSaved)
        }
    }
    
}
