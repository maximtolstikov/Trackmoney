/// Модель для отображения среднего значения по Категории
struct AverageCategory {
    
    var name: String
    var sum: Int32
    var part: Float = 0.0
    var type: String
    
    init(name: String, sum: Int32, type: String) {
        
        self.name = name
        self.sum = sum
        self.type = type
    }
}
