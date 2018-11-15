// Для описания интерфейса валидатора в паттерне Компановщик

protocol ValidatorProtocol {
    
    func validate() -> [String: String]
    func add(rule: ValidatorProtocol)
    
}
