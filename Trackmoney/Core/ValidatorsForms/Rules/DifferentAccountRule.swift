import UIKit

/// Описывает правило разных счетов при переводе
class DifferentAccountRule: ValidatorProtocol {
    
    let mainAccount: String
    let corAccount: String
    
    init(mainAccount: String, corAccount: String) {
        self.mainAccount = mainAccount
        self.corAccount = corAccount
    }
    
    func validate() -> [String: String] {
        
        var error = [String: String]()
        
        
        if mainAccount == corAccount {
            error["accountIs'tDifferent"] = NSLocalizedString("accountIs'tDifferent", comment: "")
        }
        
        return error
    }
    
    func add(rule: ValidatorProtocol) {}
    
}
