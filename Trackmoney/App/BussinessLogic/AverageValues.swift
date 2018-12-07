import Foundation

/// Вычисляет средние значения за период
struct AverageValues {
    
    var categories: [CategoryTransaction]
    
    init(_ categories: [CategoryTransaction]) {
        
        self.categories = categories
    }
    
    // Возвращает отсортированный по убыванию массив средних значений категорий
    mutating func collectCategories(_ transactions: [Transaction]) -> [AverageCategory] {
        
        var array = [AverageCategory]()
        var sortedCategories = [CategoryTransaction]()
        
        if transactions.first?.type == TransactionType.expense.rawValue {
            sortedCategories = categories
                .filter { $0.type == CategoryType.expense.rawValue }
        } else {
            sortedCategories = categories
                .filter { $0.type == CategoryType.income.rawValue }
        }
        
        for category in sortedCategories {
            
            let totalSum = transactions.filter { $0.category == category.name }
                .map { $0.sum }
                .reduce (0, +)
            
            array.append(AverageCategory(name: category.name,
                                         sum: totalSum,
                                         type: category.type))
        }
        
        let totalSumAllCategories = array.map { $0.sum }.reduce(0, +)
        
        let averageCategories = array.map { (element) -> AverageCategory in
            
            var category = element
            category.part = Float(category.sum) / Float(totalSumAllCategories)
            return category
        }
        
        return averageCategories.sorted { $0.sum > $1.sum }
    }
}
