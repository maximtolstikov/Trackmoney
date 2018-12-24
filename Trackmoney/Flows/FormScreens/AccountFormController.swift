import UIKit

class AccountFormController: BaseFormController {
    
    //поставщик данных
    var dataProvider: DataProviderProtocol?
    var accountForUpdate: Account? {
        didSet {
            nameTextField.text = accountForUpdate?.name
            sumTextField.isHidden = true
        }
    }
    
    let nameTextField = UITextField()
    let sumTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

                createSumTextField()
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
    private func createSumTextField() {
        
        viewOnScroll.addSubview(sumTextField)
        if let account = accountForUpdate {
            sumTextField.isHidden = true
            sumTextField.text = String(account.sum)
        }
        sumTextField.borderStyle = .line
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.keyboardType = UIKeyboardType.numberPad
        sumTextField.textAlignment = .center
        sumTextField.placeholder = NSLocalizedString("sumTextFildPlaceholder", comment: "")
        
        sumTextField.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        sumTextField.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                            multiplier: 2 / 3).isActive = true
        sumTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sumTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                             constant: -40).isActive = true
        
    }
    
    // создает текстовое поле для ввода имени счета
    private func createNameTextField() {
        
        viewOnScroll.addSubview(nameTextField)
        nameTextField.borderStyle = .line
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textAlignment = .center
        nameTextField.placeholder = NSLocalizedString("nameTextFildPlaceholder", comment: "")
        
        nameTextField.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        nameTextField.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                            multiplier: 2 / 3).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: sumTextField.topAnchor,
                                              constant: -40).isActive = true
    }    
    
    // MARK: - Button's methods
    
    @objc override func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc override func tapSaveButton() {

        validate()
    }
    
    // запускаем проверку полей
    private func validate() {
        
        guard let nameText = nameTextField.text, let sumText = sumTextField.text else {
            assertionFailure()
            return
        }
        
        let nameTextFieldValidateResult = NameTextFieldValidate(text: nameText).validate()
        
        if nameTextFieldValidateResult.isEmpty {
            
            var sumTextFieldValidateResult = [String: String]()
            
            if !sumTextField.isHidden {
                sumTextFieldValidateResult = SumTextFieldValidate(text: sumText)
                    .validate()
            }
            if sumTextFieldValidateResult.isEmpty {
                
                guard let sum = Int32(sumText) else {
                    assertionFailure()
                    return
                }
                
                sendMessage(with: nameText, and: sum)
                
            } else {
                showPromptError(result: sumTextFieldValidateResult,
                                field: self.sumTextField)                
            }
            
        } else {
            showPromptError(result: nameTextFieldValidateResult,
                            field: self.nameTextField)
        }
        
    }
    
    // Вызываем окно подсказки и делаем красную рамку
    private func showPromptError(result: [String: String],
                                 field: UITextField) {
        for (_, value) in result {
            showPromptView(with: value)
            addRedBorderTo(control: field)
        }
    }

    // Отправляет данные на сохранение
    private func sendMessage(with name: String, and sum: Int32) {
        
        let message = MessageManager()
            .craftAccounеMessage(nameAccount: name,
                                  sumAccount: sum,
                                  id: accountForUpdate?.id)
        
        dataProvider?.save(message: message, completion: { [weak self] (error) in
            
            guard error == nil else {
                NeedCancelAlert().show(controller: self!, title: error?.description, body: nil)
                return
            }
            self!.dismiss(animated: true, completion: nil)
        })
    }
 
    // MARK: - Методы уведомления TextField
    
    @objc override func responseTextField(_ notification: Notification) {
        nameTextField.updateFocusIfNeeded()
    }
    
    @objc override func didChangeText(_ notification: Notification) {
        
        // swiftlint:disable next force_cast
        let textField = notification.object as! UITextField
        
        DispatchQueue.main.async {
            self.animateSlideUpPromt(completion: nil)
            self.removeRedBorderTo(control: textField)
        }
    }
    
}
