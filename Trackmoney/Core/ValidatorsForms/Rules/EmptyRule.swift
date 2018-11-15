// Для описания правила проверки на пустой текст

import UIKit

class EmptyRule: ValidatorProtocol {
    
    let textFromForm: String
    
    init(text: String) {
        self.textFromForm = text
    }
    
    func validate() -> [String: String] {
        
        var error = [String: String]()
        
        if self.textFromForm == "" {
            error["textEmpty"] = NSLocalizedString("errorTextFormEmpty", comment: "")
        }
        
        return error
    }
    
    func add(rule: ValidatorProtocol) {}
    
}
