import Foundation

/// Упаковывает и извлекает данные в/из CSV файл
class LocalArchiveManagerImpl: LocalArchiveManager {
    
    // MARK: - Constants
    
    let fileManager = FileManager.default

    // MARK: - Public methods
    
    // Упаковывает данные в файл
    func create(completionHandler: @escaping (URL?) -> Void) {
        
        let createrString = CreaterStringsFromEntity()
        let name = currentName()
        
        createrString.string { [weak self] (csvString) in
            guard let string = csvString,
                let url = self?.writeToFile(line: string, withName: name) else {
                    completionHandler(nil)
                    return }
            completionHandler(url)
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

    // MARK: - Private methods
    
    /// Записывает строку в файл
    ///
    /// - Parameters:
    ///   - string: Строка для записи
    ///   - withName: Имя файла
    /// - Returns: URL к созданному файлу или nil
    private func writeToFile(line: String, withName: String) -> URL? {
        do {
            let path = try fileManager.url(
                for: .documentDirectory,
                in: .allDomainsMask,
                appropriateFor: nil,
                create: true)
            
            let fileURL = path.appendingPathComponent(withName)
            try line.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // Возвращает имя с текущим временем
    private func currentName() -> String {
        let date = DateSetter().date().replacingOccurrences(of: ",", with: ".")
        
        return "trackmoney" + "\(date)" + ".csv"
    }
    
}
