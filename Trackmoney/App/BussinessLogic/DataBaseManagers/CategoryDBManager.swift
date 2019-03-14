//swiftlint:disable force_cast
import CoreData
import UIKit

class CategoryDBManager: DBManager, DBManagerProtocol {
    
    lazy var transactionDBManager = TransactionDBManager()
    
    func create(_ message: Message) -> (DBEntity?, DBError?) {
        
        // Проверка что объекта с таким именем нет в базе
        guard let name = message[.name] else {
            return (nil, DBError.messageHaventRequireValue)
        }
        
        let predicateName = NSPredicate(format: "name = %@", name as! String)
        let resultForName = get(predicateName)
        
        guard let response = resultForName, response.isEmpty else {
            return (nil, DBError.objectIsExistAlready)
        }
        
        // Получение списока категорий создоваемого типа до добавления для сортировки
        let all = NSPredicate(value: true)
        
        guard let resultForAll = get(all) else {
            return (nil, DBError.objectCanntGetFromBase)
        }
        
        let categories = resultForAll as! [CategoryTransaction]
        let sortManager: CustomSortManager
        let type = message[.type] as! String
        if type == CategoryType.expense.rawValue {
            sortManager = CustomSortManager(.expense)
        } else {
            sortManager = CustomSortManager(.income)
        }
        let sortedByType = categories.filter { $0.type == type }
        
        // Создание нового объекта
        let category = CategoryTransaction(context: context)
        
        category.id = UUID().uuidString
        category.name = message[.name] as! String
        category.icon = message[.icon] as! String
        category.type = type
        
        if let parentName = message[.parent] {
            let predicate = NSPredicate(format: "name = %@", parentName as! String)
            let result = get(predicate)
            
            guard let object = result?.first else {
                return (nil, DBError.objectCanntGetFromBase)
            }
            
            let parent = object as! CategoryTransaction
            category.parent = parent
            parent.addToChild(category)
        }
        
        do {
            try context.save()
            // Сортирует список с пользовательской последовательностью
            // и добавляет в конец новый элемент
            let sortedList = sortManager.sortedArray(sortedByType)
            _ = sortManager.add(element: category, in: sortedList)            
            
            return (category, nil)
            
        } catch {
            return (nil, DBError.contextDoNotBeSaved)
        }
    }
    
    func get(_ predicate: NSPredicate) -> [DBEntity]? {
        
        let fetchRequest: NSFetchRequest<CategoryTransaction> = CategoryTransaction.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
            
        } catch {
            return nil
        }
    }
    
    func update(_ message: Message) -> DBError? {
        
        let predicate = NSPredicate(format: "id = %@", message[.id] as! String)
        let result = get(predicate) as! [CategoryTransaction]?
        
        guard let category = result?.first else {
            return DBError.objectIsNotExist
        }
        
        if let parent = message[.parent] {
            
            if let oldParentName = category.parent?.name {
                
                let predicate = NSPredicate(format: "name = %@", oldParentName)
                let result = get(predicate) as! [CategoryTransaction]?
                
                guard let oldParent = result?.first else {
                    return DBError.objectIsNotExist
                }
                
                oldParent.removeFromChild(category)
            }
            
            let predicate = NSPredicate(format: "name = %@", parent as! String)
            let result = get(predicate) as! [CategoryTransaction]
            
            guard let newParent = result.first else {
                return DBError.objectIsNotExist
            }
            
            category.parent = newParent
            newParent.addToChild(category)
        }
        
        if messageManager.isExistValue(for: .name, in: message) {
            
            let newName = message[.name] as! String
            
            let predicate = NSPredicate(format: "category = %@", category.name)
            let result = transactionDBManager.get(predicate)
            
            guard let objects = result else {
                return DBError.objectCanntGetFromBase
            }

            let transactions = objects as! [Transaction]
            _ = transactions.map { $0.category = newName }
            
            category.name = newName
        }
        
        if messageManager.isExistValue(for: .icon, in: message) {
            category.icon = message[.icon] as! String
        }
        
        return saveContext()
    }
    
    func delete(_ id: String, force: Bool) -> DBError? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let result = get(predicate) as! [CategoryTransaction]?
        
        guard let object = result?.first else {
            return DBError.objectIsNotExist
        }
        
        context.delete(object)
        return saveContext()
    }
    
    // Сохраняет контекст
    private func saveContext() -> DBError? {
        
        do {
            try context.save()
            return nil
        } catch {
            return DBError.contextDoNotBeSaved
        }
    }
    
}
