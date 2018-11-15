/// Для проверки выбора счетов при переводе
class TransferValidator: ValidatorProtocol {
    
    private var rules = [ValidatorProtocol]()

    var mainAccount: String = ""
    var corAccount: String = ""
    var sum: String = ""
    
    func setData(mainAccount: String, corAccont: String, sum: String) {
        self.mainAccount = mainAccount
        self.corAccount = corAccont
        self.sum = sum
    }
    
    func validate() -> [String: String] {
        
        var errors = [String: String]()
        
        let differentAccountRule = DifferentAccountRule(mainAccount: mainAccount,
                                                        corAccount: corAccount)
        let emptyAccount = EmptyAccountRule(corAccount: corAccount)
        let textToNumber = TextToNumberRule(text: sum)
        let negateveSum = NegativeSumRule(text: sum)
        
        add(rule: differentAccountRule)
        add(rule: emptyAccount)
        add(rule: textToNumber)
        add(rule: negateveSum)
        
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
