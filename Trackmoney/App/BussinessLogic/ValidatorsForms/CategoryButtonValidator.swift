/// Для проверки кнопки выбора Category
class CategoryButtonValidator: ValidatorProtocol {
    
    private var rules = [ValidatorProtocol]()
    
    var name: String = ""
    
    init(category: String) {
        self.name = category
    }
    
    func validate() -> [String: String] {
        
        var errors = [String: String]()
        
        for rule in rules {
            let result: [String: String] = rule.validate()
            if let key = result.keys.first {
                errors[key] = result[key]
            }
        }
        
        return errors
    }
    
    func add(rule: ValidatorProtocol) {
        self.rules.append(rule)
    }
    
}
