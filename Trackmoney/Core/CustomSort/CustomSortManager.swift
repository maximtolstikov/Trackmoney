import Foundation

/// Управляет логикой сортировки эелементов в списке
struct CustomSortManager {
    
    let userDefalts = UserDefaults.standard
    let entity: DBEntity.Type
    var key: String {
        return entity == Account.self ? "sortListAccounts" : "sortListCategories"
    }
    
    /// Возвращает массив с пользовательской сортировкой
    func sortedArray<T: DBEntity>(_ array: [T]) -> [T] {
        
        let dict = checkDictCorrectFor(array)
        var newArray = array
        
        for element in array {
            guard let index = dict[element.name] else {
                assertionFailure()
                return newArray
            }            
            newArray[index] = element
        }
        
        return newArray
    }
    
    /// Защищает массив имен от не соответствия имен в словаре
    func checkDictCorrectFor<T: DBEntity>(_ array: [T]) -> [String: Int] {
        
        guard let dict = userDefalts.dictionary(forKey: key) as? [String: Int] else {
            return saveCurrentOrder(array)
        }
        
        var mySet = Set<String>()
        // Создает множество из значений словаря
        for name in dict.keys {
            mySet.insert(name)
        }
        // Сохраняет словарь с текущим порядком если есть не совпадение имен
        // в массиве и в словаре
        for entity in array {
            guard mySet.contains(entity.name) else {
                return saveCurrentOrder(array)
            }
        }
        // Сохраняет словарь с текущим порядком если количество имен в массиве
        // не совпадает с словарем
        guard mySet.count == array.count else {
            return saveCurrentOrder(array)
        }
        
        return dict
    }
    
    // Сохраняет порядок в UserDefalts
    private func saveCurrentOrder<T: DBEntity>(_ array: [T]) -> [String: Int] {
        
        var dict = [String: Int]()
        for (index, value) in array.enumerated() {
            dict[value.name] = index
        }
        
        userDefalts.set(dict, forKey: key)
        
        //swiftlint:disable next force_cast
        return userDefalts.dictionary(forKey: key) as! [String: Int]
    }
    
    /// Добавляет элемент
    func add<T: DBEntity>(element: T, in array: [T]) {
        
        var newArray = array
        newArray.append(element)
        _ = saveCurrentOrder(newArray)
    }
    
    /// Удаляет элемент
    func remove<T: DBEntity>(element: T, in array: [T]) {
        
        let newArray = array.filter { $0.name != element.name }
        _ = saveCurrentOrder(newArray)        
    }
    
    /// Перемещает элемент
    func swapElement<T: DBEntity>(array: [T]) {
        
         _ = saveCurrentOrder(array)
 
    }
    
}
