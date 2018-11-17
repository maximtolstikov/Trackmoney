// Для описания контроллера создания и редактирования транзакции

import UIKit

class TransactionFormController: BaseFormController {
    
    //поставщик данных
    var dataProvider: DataProviderProtocol?
    
    var accounts: [Account]?
    var categories: [CategoryTransaction]?
    
    var topChooseButtonName: String?
    var bottomChooseButtonName: String?
    var transactionType: TransactionType?
    
    
    let bottomChooseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("-----------", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sumTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let topChooseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("-----------", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        createBottomChoseButton()
        createSumTextField()
        createTopChoseButton()
    }
    
    // делает текстовое поле активным и вызывается клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.sumTextField.becomeFirstResponder()
        }
    }
    
    //получаем данные для контроллера
    func getData() {
        
        dataProvider?.loadData()
    }
    
    
    // создаем нижнюю кнопку выбора Счета или Категории
    func createBottomChoseButton() {
        
        if let name = bottomChooseButtonName {
            bottomChooseButton.setTitle(name, for: .normal)
        }
        viewOnScroll.addSubview(bottomChooseButton)
        
        bottomChooseButton.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor).isActive = true
        bottomChooseButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor, multiplier: 2 / 3).isActive = true
        bottomChooseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bottomChooseButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                                   constant: -40).isActive = true
        bottomChooseButton.addTarget(self, action: #selector(tapBottomChooseButton),
                                     for: .touchUpInside)
        
    }
    
    // создает текстовое поле для ввода суммы
    func createSumTextField() {
        
        viewOnScroll.addSubview(sumTextField)
        sumTextField.keyboardType = UIKeyboardType.numberPad
        sumTextField.textAlignment = .center
        sumTextField.placeholder = "sum"
        
        sumTextField.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        sumTextField.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                            multiplier: 2 / 3).isActive = true
        sumTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sumTextField.bottomAnchor.constraint(equalTo: bottomChooseButton.topAnchor, constant: -40).isActive = true
        
    }
    
    // создает верхнюю кнопку выбора Счета
    func createTopChoseButton() {
        
        if let name = topChooseButtonName {
            topChooseButton.setTitle(name, for: .normal)
        }
        viewOnScroll.addSubview(topChooseButton)
        
        topChooseButton.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor).isActive = true
        topChooseButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor, multiplier: 2 / 3).isActive = true
        topChooseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topChooseButton.bottomAnchor.constraint(equalTo: sumTextField.topAnchor,
                                                constant: -40).isActive = true
        topChooseButton.addTarget(self, action: #selector(tapTopChooseButton),
                                  for: .touchUpInside)
        
    }
    
    @objc override func responseTextField(_ notification: Notification) {
        sumTextField.updateFocusIfNeeded()
    }
    
    @objc override func didChangeText(_ notification: Notification) {
        DispatchQueue.main.async {
            self.removeRedBorderTo(control: self.sumTextField)
            self.animateSlideUpPromt(completion: nil)
        }
    }
    
    // MARK: - Button's methods
    
    @objc override func tapCancelButton() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc override func tapSaveButton() {
        
        validate()
    }
    
    // Проверяет поля на соответсвие правилам
    func validate() {        
        
        guard let sumText = sumTextField.text,
            let topChooseButtonText = self.topChooseButton.titleLabel?.text,
            let bottomChooseButtonText = self.bottomChooseButton.titleLabel?.text
            else {
                assertionFailure()
                return
        }
        
        let mainAccountValidateResult = MainAccountButtonValidator(account: topChooseButtonText).validate()
        if mainAccountValidateResult.isEmpty {
            
            let sumTextFieldValidateResult = SumTextFieldValidate(text: sumText).validate()
            if sumTextFieldValidateResult.isEmpty {
                
                var bottomButtonValidateResult = [String: String]()
                
                switch transactionType {
                case .transfer?:
                    bottomButtonValidateResult = CorAccountButtonValidator(
                        mainAccount: topChooseButtonText,
                        corAccount: bottomChooseButtonText).validate()
                default:
                    bottomButtonValidateResult = CategoryButtonValidator(category: bottomChooseButtonText).validate()
                }
                
                if bottomButtonValidateResult.isEmpty {
                    
                    sendMessage()
                    dismiss(animated: false, completion: nil)
                    
                } else {
                    showPromptError(result: bottomButtonValidateResult,
                                    field: self.bottomChooseButton)
                }
                
            } else {
                showPromptError(result: sumTextFieldValidateResult,
                                field: self.sumTextField)
            }
            
        } else {
            showPromptError(result: mainAccountValidateResult,
                            field: self.topChooseButton)
        }
        
    }
    
    // Отправляет данные формы в базу
    func sendMessage() {
        
        guard let type = transactionType,
            let topButtonText = topChooseButton.currentTitle,
            let sumText = sumTextField.text,
            let sum = Int32(sumText),
            let bottomButtonText = bottomChooseButton.currentTitle else {
                assertionFailure()
                return
        }
        
        let message = MessageManager()
            .craftTransactionMessage(transactionType: type,
                                     topButton: topButtonText,
                                     sum: sum,
                                     bottomButton: bottomButtonText)
        dataProvider?.save(message: message)
    }
    
    // Вызываем окно подсказки и делаем красную рамку
    private func showPromptError(result: [String: String],
                                 field: UIControl) {
        for (_, value) in result {
            showPromptView(with: value)
            addRedBorderTo(control: field)
        }
    }
    
    @objc func tapTopChooseButton() {
        
        removeRedBorderTo(control: topChooseButton)
        self.animateSlideUpPromt(completion: nil)
        
        guard let arrayAccounts = accounts else {
            assertionFailure("список счетов не получен из базы")
            return
        }
        AlertManager().showSelectAccounts(accounts: arrayAccounts,
                                          controller: self) { [weak self] (name) in
            self?.topChooseButton.setTitle(name, for: .normal)
        }
    }
    
    @objc func tapBottomChooseButton() {
        
        removeRedBorderTo(control: bottomChooseButton)
        self.animateSlideUpPromt(completion: nil)
        
        if transactionType == TransactionType.income ||
            transactionType == TransactionType.expense {
            
            guard let arrayCategories = categories else {
                assertionFailure("список счетов не получен из базы")
                return
            }
            AlertManager().showSelectCategories(categories: arrayCategories,
                                                controller: self) { [weak self] (name) in
                self?.bottomChooseButton.setTitle(name, for: .normal)
            }
            
        } else if transactionType == TransactionType.transfer {
            
            guard let arrayAccounts = accounts else {
                assertionFailure("список счетов не получен из базы")
                return
            }
            AlertManager().showSelectAccounts(accounts: arrayAccounts,
                                              controller: self) { [weak self] (name) in
                self?.bottomChooseButton.setTitle(name, for: .normal)
            }
        }
        
    }
    
}
