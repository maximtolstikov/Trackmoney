class NameTextFieldValidate: ValidatorProtocol {
    
    var textForValidate: String
    private var rules = [ValidatorProtocol]()
    
    init(text: String) {
        self.textForValidate = text
    }
    
    func validate() -> [String: String] {
        
        var errors = [String: String]()
        
        let emptyRule = EmptyRule(text: self.textForValidate)
        add(rule: emptyRule)
        
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
