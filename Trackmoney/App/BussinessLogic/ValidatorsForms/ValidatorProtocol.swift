protocol ValidatorProtocol {
    
    func validate() -> [String: String]
    func add(rule: ValidatorProtocol)
    
}
