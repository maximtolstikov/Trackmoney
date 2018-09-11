// Для описания методов BD у Категорий

//swiftlint:disable force_cast

import CoreData
import UIKit

class CategoryDBManager: DBManager, DBManagerProtocol {

    
    func create(message: [MessageKeyType: Any]) -> Bool {
        
        let newCategory = Category(context: context)
        
        newCategory.nameCategory = message[.nameCategory] as! String
        newCategory.iconCategory = message[.iconCategory] as? String
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
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
    
    
    //Возвращает категорию по имени
    func getOneObject(for name: String) -> Category? {
        
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
    
    
    func change(message: [MessageKeyType: Any]) -> Bool {
    
        guard let category = getOneObject(for: message[.nameCategory] as! String) else {
            assertionFailure()
            return false
        }
        
        if mManager.isExistValue(for: .newName, in: message) {
            category.nameCategory = message[.newName] as! String
            //TODO: сдесь нужен итератор по Транзакциям
        }
        if mManager.isExistValue(for: .iconCategory, in: message) {
            category.iconCategory = message[.iconCategory] as? String
        }

        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    func delete(message: [MessageKeyType: Any]) -> Bool {
        
        guard let category = getOneObject(for: message[.nameCategory] as! String) else {
            assertionFailure()
            return false
        }
        
        //TODO: сдесь нужен итератор по Транзакциям

        context.delete(category)

        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
}
