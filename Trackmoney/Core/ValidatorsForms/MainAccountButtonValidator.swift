/// Для проверки кнопки выбора главного Счета
class MainAccountButtonValidator: ValidatorProtocol {
    
    private var rules = [ValidatorProtocol]()
    
    var mainAccount: String = ""
    
    init(account: String) {
        self.mainAccount = account
    }
    
    func validate() -> [String: String] {
        
        var errors = [String: String]()
        
        let emptyAccount = EmptyAccountRule(corAccount: mainAccount)
        
        add(rule: emptyAccount)
        
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
