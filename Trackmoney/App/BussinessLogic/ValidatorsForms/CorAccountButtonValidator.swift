/// Для проверки кнопки выбора корреспондирующего Счета
class CorAccountButtonValidator: ValidatorProtocol {
    
    private var rules = [ValidatorProtocol]()
    
    var mainAccount: String = ""
    var corAccount: String = ""
    
    init(mainAccount: String, corAccount: String) {
        self.mainAccount = mainAccount
        self.corAccount = corAccount
    }
    
    func validate() -> [String: String] {
        
        var errors = [String: String]()
        
        let emptyAccount = EmptyAccountRule(corAccount: corAccount)
        let differentAccount = DifferentAccountRule(mainAccount: mainAccount,
                                                    corAccount: corAccount)
        
        add(rule: emptyAccount)
        add(rule: differentAccount)
        
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
