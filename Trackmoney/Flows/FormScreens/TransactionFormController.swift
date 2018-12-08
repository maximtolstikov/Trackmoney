import CoreData
import UIKit

/// Описывает контроллер создания и редактирования транзакции
class TransactionFormController: BaseFormController {
    
    //поставщик данных
    var dataProvider: DataProviderProtocol?
    
    // Переменные для заполнения формы
    var topChooseButtonText: String?
    var sumTextFieldText: String?
    var bottomChooseButtonText: String?
    var note: String?
    
    var accounts: [Account]?
    var categories: [CategoryTransaction]?
    
    var transactionType: TransactionType?
    var transactionID: String?
    
    
    let bottomChooseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let noteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider?.loadData()
        createBottomChoseButton()
        createSumTextField()
        createTopChoseButton()
        createNoteButton()
    }
    
    // делает текстовое поле активным и вызывается клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.sumTextField.becomeFirstResponder()
        }
    }
    
    // Создаем нижнюю кнопку выбора Счета или Категории
    func createBottomChoseButton() {
        
        bottomChooseButton.setTitle(NSLocalizedString("emptyTitle", comment: ""),
                                    for: .normal)
        if let name = bottomChooseButtonText {
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
        if let text = bottomChooseButtonText {
            bottomChooseButton.titleLabel?.text = text
        }
        
    }
    
    // Создает текстовое поле для ввода суммы
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
        
        if let text = sumTextFieldText {
            sumTextField.text = text
        }
        
    }
    
    // Создает верхнюю кнопку выбора Счета
    func createTopChoseButton() {
        
        topChooseButton.setTitle(NSLocalizedString("emptyTitle", comment: ""),
                                 for: .normal)
        if let name = topChooseButtonText {
            topChooseButton.setTitle(name, for: .normal)
        }
        viewOnScroll.addSubview(topChooseButton)
        
        topChooseButton.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        topChooseButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                               multiplier: 2 / 3).isActive = true
        topChooseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topChooseButton.bottomAnchor.constraint(equalTo: sumTextField.topAnchor,
                                                constant: -40).isActive = true
        topChooseButton.addTarget(self, action: #selector(tapTopChooseButton),
                                  for: .touchUpInside)
    }
    
    // Создает верхнюю кнопку вызова заметки
    func createNoteButton() {
        
        noteButton.setTitle(NSLocalizedString("noteTitle", comment: ""),
                            for: .normal)
        viewOnScroll.addSubview(noteButton)
        
        noteButton.leftAnchor.constraint(equalTo: topChooseButton.rightAnchor,
                                         constant: 8).isActive = true
        noteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        noteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        noteButton.bottomAnchor.constraint(equalTo: bottomChooseButton.topAnchor,
                                           constant: -40).isActive = true
        noteButton.addTarget(self, action: #selector(tapNoteButton),
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
        
        let mainAccountValidateResult = MainAccountButtonValidator(account: topChooseButtonText)
            .validate()
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
                    bottomButtonValidateResult = CategoryButtonValidator(category: bottomChooseButtonText)
                        .validate()
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
        
        let text = note ?? ""
        
        let message = MessageManager()
            .craftTransactionMessage(transactionType: type,
                                     topButton: topButtonText,
                                     sum: sum,
                                     bottomButton: bottomButtonText,
                                     note: text,
                                     id: transactionID)
        dataProvider?.save(message: message)
    }
    
    // Вызываем окно подсказки и делаем красную рамку
    private func showPromptError(result: [String: String],
                                 field: UIControl) {
        
        if let value = result.first?.value {
            showPromptView(with: value)
        }
        addRedBorderTo(control: field)
    }
    
    @objc func tapTopChooseButton() {
        
        removeRedBorderTo(control: topChooseButton)
        self.animateSlideUpPromt(completion: nil)
        
        guard let arrayAccounts = accounts else {
            assertionFailure("список счетов не получен из базы")
            return
        }
        ChooseAccountAlert().show(accounts: arrayAccounts,
                                  controller: self) { [weak self] (name) in
                                    self?.topChooseButton.setTitle(name, for: .normal)
        }
    }
    
    @objc func tapBottomChooseButton() {
        
        removeRedBorderTo(control: bottomChooseButton)
        self.animateSlideUpPromt(completion: nil)
        
        if transactionType == TransactionType.transfer {
            
            guard let arrayAccounts = accounts else {
                assertionFailure("список счетов не получен из базы")
                return
            }
            
            let array = arrayAccounts
                .filter { $0.name != topChooseButton.titleLabel?.text }
            ChooseAccountAlert().show(accounts: array,
                                      controller: self) { [weak self] (name) in
                                        self?.bottomChooseButton.setTitle(name, for: .normal)
            }
        } else {
            
            guard let array = categories else {
                assertionFailure("список счетов не получен из базы")
                return
            }
            
            ChooseCategoryAlert().show(categories: array,
                                       controller: self) { [weak self] (name) in
                                        self?.bottomChooseButton.setTitle(name, for: .normal)
            }
        }
    }
    
    @objc func tapNoteButton() {
        
        let text = note ?? ""
        
        NoteAlert().show(controller: self, text: text) { (string) in
            self.note = string
        }
    }
    
}
