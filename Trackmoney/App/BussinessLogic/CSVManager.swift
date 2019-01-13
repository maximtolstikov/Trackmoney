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

// swiftlint:disable line_length
import Foundation

protocol AbstractCSVManager {
    func create(with name: String) -> URL?
    func load(for name: String)
}

/// Упаковывает и извлекает данные в/из CSV файл
struct CSVManager: AbstractCSVManager {
    
    let fileManager = FileManager.default
    
    func create(with name: String) -> URL? {
        
        let predicate = NSPredicate(value: true)
        guard let accounts = AccountDBManager().get(predicate) as? [Account],
            let categories = CategoryDBManager().get(predicate) as? [CategoryTransaction],
            let tratsactions = TransactionDBManager().get(predicate) as? [Transaction] else { return nil }
        
        var csvString = ""
        csvString.append(stringFrom(accounts: accounts))
        csvString.append(";\n")
        csvString.append(stringFrom(categoryies: categories))
        csvString.append(";\n")
        csvString.append(stringFrom(transactions: tratsactions))

        return writeToFile(string: csvString, withName: name)
    }
    
    func load(for name: String) {
        
    }
    
    private func stringFrom(accounts: [Account]) -> String {
        var string = ""
        for account in accounts {
            string.append("\(account.icon),\(account.name),\(String(describing: account.sum))\n")
        }
        return string
    }
    
    private func stringFrom(categoryies: [CategoryTransaction]) -> String {
        var string = ""
        for category in categoryies {
            string.append("\(category.icon),\(category.name),\(category.type),\(category.parent?.name ?? "nil")))\n")
        }
        return string
    }
    
    private func stringFrom(transactions: [Transaction]) -> String {
        let formater = DateFormat().dateFormatter
        var string = ""
        for transaction in transactions {
            let date = transaction.date
            let stringDate = formater.string(from: date as Date)
            string.append("\(transaction.category ?? "nil"),\(transaction.corAccount ?? "nil"),\(stringDate),\(transaction.icon),\(transaction.mainAccount),\(transaction.note ?? "nil"),\(String(describing: transaction.sum)),\(String(describing: transaction.type))\n")
        }
        return string
    }
    
    private func writeToFile(string: String, withName: String) -> URL? {
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
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
