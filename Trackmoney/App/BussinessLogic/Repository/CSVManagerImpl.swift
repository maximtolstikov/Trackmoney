import Foundation

/// Упаковывает и извлекает данные в/из CSV файл
struct CSVManagerImpl: CSVManager {
    
    let fileManager = FileManager.default
//    let dateManager = 
    
    // Упаковывает данные в файл
    func create() -> String? {
        
        guard let csvString = CreaterStringsFromEntity().string() else { return nil }
        let name = currentName()
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
            let creator = CreaterEntitysFromString()
            creator.restore(from: text)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Записывает строковое представление данных в файл
    private func writeToFile(string: String, withName: String) -> String? {
        do {
            let path = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            
            let fileURL = path.appendingPathComponent(withName)
            try string.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return withName
        } catch {
            print("error creating file")
            return nil
        }
    }
    
    private func currentName() -> String {
        let date = DateSetter().date()
        return "trackmoney" + "\(date)" + ".csv"
    }
    
}
