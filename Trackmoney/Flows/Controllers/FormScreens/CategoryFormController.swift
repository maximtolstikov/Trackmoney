// Настраивает контроллер формы категории

import UIKit

class CategoryFormController: BaseFormController {
    
    var typeCategory: CategoryType!
    
    //поставщик данных
    var dataProvider: DataProviderProtocol?
    
    let typeLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNameTextField()
        createTypeLable()
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
    
    // Создает lable с типом Категории
    func createTypeLable() {
        
        viewOnScroll.addSubview(typeLable)
        typeLable.text = NSLocalizedString("typeCategory", comment: "") + " " + "\(typeCategory.rawValue)"
        typeLable.textAlignment = .center
        
        typeLable.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        typeLable.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                             multiplier: 2 / 3).isActive = true
        typeLable.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typeLable.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -40).isActive = true
    }
    
    // MARK: - Button's methods
    
    @objc override func tapCancelButton() {
       dismiss(animated: false, completion: nil)
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
                .craftCategoryFormMessage(nameCategory: nameText, type: typeCategory)
            
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
