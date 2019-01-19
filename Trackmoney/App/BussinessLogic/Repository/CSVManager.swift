// Account
//@NSManaged public var icon: String
//@NSManaged public var name: String
//@NSManaged public var sum: Int32
//@NSManaged public var type: String?  // на будущее
//@NSManaged public var id: String
// Category
//@NSManaged public var icon: String
//@NSManaged public var id: String
//@NSManaged public var name: String
//@NSManaged public var type: String
//@NSManaged public var child: NSSet?
//@NSManaged public var parent: CategoryTransaction?
// Transaction
//@NSManaged public var category: String?
//@NSManaged public var corAccount: String?
//@NSManaged public var date: NSDate
//@NSManaged public var icon: String
//@NSManaged public var mainAccount: String
//@NSManaged public var note: String?
//@NSManaged public var sum: Int32
//@NSManaged public var type: Int16
//@NSManaged public var id: String


import Foundation

protocol AbstractCSVManager {
    func create(with name: String) -> URL?
    func restorFrom(file name: String)
}

/// Упаковывает и извлекает данные в/из CSV файл
struct CSVManager: AbstractCSVManager {
    
    let fileManager = FileManager.default
    
    
    // Упаковывает данные в файл
    func create(with name: String) -> URL? {
        
        guard let csvString = CreaterStringsFromEntity().string() else { return nil }
        return writeToFile(string: csvString, withName: name)
    }
    
    // Востанавливает данные из файла
    func restorFrom(file name: String) {
        
        do {
            let path = try fileManager.url(for: .documentDirectory,
                                           in: .allDomainsMask,
                                           appropriateFor: nil,
                                           create: false)
            let fileURL = path.appendingPathComponent(name)
            guard let text = try? String(contentsOf: fileURL) else { return }
            print(text)

            let creator = CreaterEntitysFromString()
            creator.restore(from: text)            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Записываем строковое представление данных в файл
    
    private func writeToFile(string: String, withName: String) -> URL? {
        do {
            let path = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            
            let fileURL = path.appendingPathComponent(withName)
            print(fileURL)
            try string.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
        } catch {
            print("error creating file")
            return nil
        }
    }
    
}
