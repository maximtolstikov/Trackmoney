// Для описания правила конвертации строки к числу

import UIKit

class TextToNumberRule: ValidatorProtocol {
    
    let textFromForm: String
    
    init(text: String) {
        self.textFromForm = text
    }
    
    func validate() -> [String: String] {
        
        var error = [String: String]()
        
        let result = Int32(textFromForm)
        
        if result == nil {
            error["textNotToInt"] = NSLocalizedString("errorTextFormNotToInt", comment: "")
        }
        
        return error
        
    }
    
    func add(rule: ValidatorProtocol) {}
    
    
    
    
}
