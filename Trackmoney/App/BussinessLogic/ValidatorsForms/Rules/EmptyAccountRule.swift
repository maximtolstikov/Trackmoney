import UIKit

/// Описывает правило переводa на пустой счет
class EmptyAccountRule: ValidatorProtocol {
    
    let corAccount: String
    
    init(corAccount: String) {
        self.corAccount = corAccount
    }
    
    func validate() -> [String: String] {
        
        var error = [String: String]()
        
        
        if corAccount == "" || corAccount == "-----------" {
            error["notBeenSelectedAccount"] = NSLocalizedString("notBeenSelectedAccount", comment: "")
        }
        
        return error
    }
    
    func add(rule: ValidatorProtocol) {}
    
}
