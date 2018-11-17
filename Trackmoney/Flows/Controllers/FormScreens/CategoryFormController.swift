// Настраивает контроллер формы категории

import UIKit

class CategoryFormController: BaseFormController {
    
    //поставщик данных
    var dataProvider: DataProviderProtocol?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNameTextField()
    }
    
    // делает текстовое поле активным и вызывается клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.nameTextField.becomeFirstResponder()
        }
    }
    
    // создает текстовое поле для ввода суммы
    func createNameTextField() {
        
        viewOnScroll.addSubview(nameTextField)
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.textAlignment = .center
        nameTextField.placeholder = NSLocalizedString("nameTextFildPlaceholder",
                                                      comment: "")
        
        nameTextField.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        nameTextField.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                             multiplier: 2 / 3).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -40).isActive = true
        
    }
    
    // MARK: - Button's methods
    
    @objc override func tapCancelButton() {
        animateSlideUpPromt {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //проводит валидацию и сохраняет или вызывает подсказку
    @objc override func tapSaveButton() {
        
        guard let nameText = nameTextField.text else {
            assertionFailure()
            return
        }
        
        let checkRule = NameTextFieldValidate(text: nameText).validate()
        
        if checkRule.isEmpty {
            
            let message = MessageManager()
                .craftCategoryFormMessage(nameCategory: nameText)
            
            dataProvider?.save(message: message)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            for (_, value) in checkRule {
                print(value)
                showPromptView(with: value)
                addRedBorderTo(control: self.nameTextField)
                break
            }
            
        }
        
    }
    
    // Методы уведомления TextField
    @objc override func responseTextField(_ notification: Notification) {
        nameTextField.updateFocusIfNeeded()
    }
    
    @objc override func didChangeText(_ notification: Notification) {
        DispatchQueue.main.async {
            
            guard self.promptView != nil else {
                return
            }
            self.animateSlideUpPromt(completion: nil)
            self.removeRedBorderTo(control: self.nameTextField)
        }
    }
    
}
