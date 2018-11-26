// Для описания методов BD у Категорий

//swiftlint:disable force_cast

import CoreData
import UIKit

class CategoryDBManager: DBManager, DBManagerProtocol {
    
    lazy var transactionDBManager = TransactionDBManager()
    
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
        
        if getObjectByName(for: message[.nameCategory] as! String) != nil {
            return (nil, ErrorMessage(error: .categoryIsExistAlready))
        }
        
        let newCategory = CategoryTransaction(context: context)
        
        newCategory.name = message[.nameCategory] as! String
        newCategory.icon = message[.iconCategory] as? String
        newCategory.type = message[.typeCategory] as! String
        if let parent = message[.parentCategory] {
            let parentCategory = getObjectByName(for: parent as! String)
            newCategory.parent = parentCategory
            parentCategory?.addToChild(newCategory)
        }
        
        do {
            try context.save()
            return (newCategory.objectID, nil)
        } catch {
            print(error.localizedDescription)
            return (nil, ErrorMessage(error: .contextDoNotBeSaved))
        }
        
    }
    
    // Возвращает все объекты Category
    func get() -> [NSManagedObject]? {
        
        var resultRequest = [CategoryTransaction]()
        let fetchRequest: NSFetchRequest<CategoryTransaction> = CategoryTransaction.fetchRequest()
        
        do {
            resultRequest = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return resultRequest
        
    }
    
    
    //Возвращает Category по id
    func getObjectById(for id: NSManagedObjectID) -> CategoryTransaction? {
        
        return context.object(with: id) as? CategoryTransaction
        
    }
    
    
    //Возвращает категорию по имени
    func getObjectByName(for name: String) -> CategoryTransaction? {
        
        let fetchRequest: NSFetchRequest<CategoryTransaction> = CategoryTransaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            guard !result.isEmpty else {
                return nil
            }
            
            let category = result.first!   //swiftlint:disable:this force_unwrapping
            
            return category
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    // Изменяес имя или иконку Категории
    func change(message: [MessageKeyType: Any]) -> ErrorMessage? {
    
        guard let category = getObjectById(
            for: message[.idCategory] as! NSManagedObjectID) else {
            assertionFailure()
            return ErrorMessage(error: .categoryIsNotExist)
        }
        
        if mManager.isExistValue(for: .nameCategory, in: message) {

            let newName = message[.nameCategory] as! String
            
            let predicate = NSPredicate(format: "category = %@", category.name)
            if let transactions = transactionDBManager
                .getObjectBy(predicate: predicate) {
                
                _ = transactions.map { $0.category = newName }
            }
            
            category.name = newName
        }
        if mManager.isExistValue(for: .iconCategory, in: message) {
            category.icon = message[.iconCategory] as? String
        }

        return saveContext()
        
    }
    
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let category = getObjectById(
            for: message[.idCategory] as! NSManagedObjectID) else {
            assertionFailure()
            return ErrorMessage(error: .categoryIsNotExist)
        }
        
        let predicate = NSPredicate(format: "category = %@", category.name)
        if let transactions = transactionDBManager
            .getObjectBy(predicate: predicate) {

            _ = transactions.map { $0.category = "" }
        }

        context.delete(category)

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
