import Foundation

/// Вычисляет средние значения за период
struct AverageValues {
    
    var categories: [CategoryTransaction]
    let transactions: [Transaction]
    
    init(transactions: [Transaction], categories: [CategoryTransaction]) {
        
        self.transactions = transactions
        self.categories = categories
    }
    
    // Возвращает отсортированный по убыванию массив средних значений категорий
    mutating func collectCategories() -> [AverageCategory] {
        
        var array = [AverageCategory]()
        
        for category in categories {
            
            let totalSum = transactions.filter { $0.category == category.name }
                .map { $0.sum }
                .reduce (0, +)
            
            array.append(AverageCategory(name: category.name, sum: totalSum))
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
