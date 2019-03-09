import Foundation

/// Упаковывает и извлекает данные в/из CSV файл
struct CSVManagerImpl: CSVManager {
    
    let fileManager = FileManager.default
    
    
    // Упаковывает данные в файл
    func create(completionHandler: @escaping (String?) -> Void) {
        
        let createrString = CreaterStringsFromEntity()
        let name = currentName()
        
        createrString.string { (csvString) in
            guard let string = csvString,
                let nameFile = self.writeToFile(string: string, withName: name) else {
                    completionHandler(nil)
                    return }
            completionHandler(nameFile)
        }
    }
    
    
    // Востанавливает данные из файла
    func restorFrom(file name: String, completionHandler: @escaping (Bool) -> Void) {
        
        do {
            let url = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            let fileURL = url.appendingPathComponent(name)
            guard let text = try? String(contentsOf: fileURL) else { return }
            let creator = CreaterEntitysFromString()
            let result = creator.restore(from: text)
            completionHandler(result)
            
        } catch let error {
            print(error.localizedDescription)
            completionHandler(false)
        }
    }
    
    
    // Возвращает список файлов архивов в папке Документы
    func archivesList(completionHandler: @escaping ([String]?) -> Void) {
        
        guard let url = fileManager.urls(
            for: .documentDirectory,
            in: .allDomainsMask).first,
            let enumerator = fileManager.enumerator(atPath: url.path),
            let paths = enumerator.allObjects as? [String] else {
                completionHandler(nil)
                return }
        
        let archives = paths.filter { $0.contains("trackmoney") && $0.contains("csv") }
        completionHandler(archives)
    }
    
    
    // Удаляет архивы находящеся в списке
    func deleteItems(_ list: [String], completion: @escaping () -> Void) {
        
        do {
            let url = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            
            for archivName in list {
                let fileURL = url.appendingPathComponent(archivName)
                try fileManager.removeItem(at: fileURL)
            }
            completion()
            
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
    
    // Возвращает имя с текущим временем
    private func currentName() -> String {
        let date = DateSetter().date()
        return "trackmoney" + "\(date)" + ".csv"
    }
    
}
