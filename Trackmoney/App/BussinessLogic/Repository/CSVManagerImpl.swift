import Foundation

/// Упаковывает и извлекает данные в/из CSV файл
struct CSVManagerImpl: CSVManager {
    
    let fileManager = FileManager.default

    
    // Упаковывает данные в файл
    func create() -> String? {
        
        guard let csvString = CreaterStringsFromEntity().string() else { return nil }
        let name = currentName()
        return writeToFile(string: csvString, withName: name)
    }
    
    
    // Востанавливает данные из файла
    func restorFrom(file name: String) {
        
        do {
            let url = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: false)
            
            let fileURL = url.appendingPathComponent(name)
            guard let text = try? String(contentsOf: fileURL) else { return }
            let creator = CreaterEntitysFromString()
            creator.restore(from: text)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    // Возвращает список файлов архивов в папке Документы
    func archivesList() -> [String]? {
        
        guard let url = fileManager.urls(for: .documentDirectory,
                                         in: .allDomainsMask).first,
            let enumerator = fileManager.enumerator(atPath: url.path),
            let paths = enumerator.allObjects as? [String] else { return nil }
        
        return paths.filter { $0.contains("trackmoney") && $0.contains("csv") }
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
