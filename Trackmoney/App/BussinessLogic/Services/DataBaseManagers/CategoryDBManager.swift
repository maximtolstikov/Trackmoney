// Для описания методов BD у Категорий

//swiftlint:disable force_cast

import CoreData
import UIKit

class CategoryDBManager: DBManager, DBManagerProtocol {
    
    func create(message: [MessageKeyType: Any]) -> (NSManagedObjectID?, ErrorMessage?) {
        
        if getObjectByName(for: message[.nameCategory] as! String) != nil {
            return (nil, ErrorMessage(error: .categoryIsExistAlready))
        }
        
        let newCategory = Category(context: context)
        
        newCategory.nameCategory = message[.nameCategory] as! String
        newCategory.iconCategory = message[.iconCategory] as? String
        
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
        
        var resultRequest = [Category]()
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            resultRequest = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return resultRequest
        
    }
    
    
    //Возвращает Category по id
    func getObjectById(for id: NSManagedObjectID) -> Category? {
        
        return context.object(with: id) as? Category
        
    }
    
    
    //Возвращает категорию по имени
    func getObjectByName(for name: String) -> Category? {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameCategory = %@", name)
        
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
            category.nameCategory = message[.nameCategory] as! String
            //TODO: сдесь нужен итератор по Транзакциям
        }
        if mManager.isExistValue(for: .iconCategory, in: message) {
            category.iconCategory = message[.iconCategory] as? String
        }

        return saveContext()
        
    }
    
    func delete(message: [MessageKeyType: Any]) -> ErrorMessage? {
        
        guard let category = getObjectById(
            for: message[.idCategory] as! NSManagedObjectID) else {
            assertionFailure()
            return ErrorMessage(error: .categoryIsNotExist)
        }
        
        //TODO: сдесь нужен итератор по Транзакциям

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
