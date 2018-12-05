import UIKit

/// Описывает правило отрицательной суммы
class NegativeSumRule: ValidatorProtocol {
    
    let textFromForm: String
    
    init(text: String) {
        self.textFromForm = text
    }
    
    func validate() -> [String: String] {
        
        var error = [String: String]()
        
        
        if self.textFromForm.prefix(1) == "-" {
            error["negativeNumber"] = NSLocalizedString("errorNegativeNumber", comment: "")
        }
        
        return error
    }
    
    func add(rule: ValidatorProtocol) {}
    
}
