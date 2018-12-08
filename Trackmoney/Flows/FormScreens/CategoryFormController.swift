import UIKit

/// Класс контроллера формы категории
class CategoryFormController: BaseFormController {
    
    var typeCategory: CategoryType!
    var categories: [CategoryTransaction]?
    var categotyForUpdate: CategoryTransaction?
    
    // Поставщик данных
    var dataProvider: DataProviderProtocol?
    
    let topChooseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        dataProvider?.loadData()
        setupNameTextField()
        setupTopChoseButton()
        setupTypeLable()
    }
    
    // Делает текстовое поле активным и вызывается клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.nameTextField.becomeFirstResponder()
        }
    }
    
    // Создает текстовое поле для ввода суммы
    func setupNameTextField() {
        
        viewOnScroll.addSubview(nameTextField)
        
        if categotyForUpdate != nil {
            nameTextField.text = categotyForUpdate?.name
        }
        
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.textAlignment = .center
        nameTextField.placeholder = NSLocalizedString("nameTextFildPlaceholder",
                                                      comment: "")
        
        nameTextField.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        nameTextField.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                             multiplier: 2 / 3).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                              constant: -40).isActive = true
    }
    
    // Создает lable с типом Категории
    func setupTypeLable() {
        
        viewOnScroll.addSubview(typeLable)
        
        typeLable.text = typeCategory.rawValue
        typeLable.textAlignment = .center
        
        typeLable.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor)
            .isActive = true
        typeLable.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                         multiplier: 2 / 3).isActive = true
        typeLable.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typeLable.bottomAnchor.constraint(equalTo: topChooseButton.topAnchor,
                                          constant: -40).isActive = true
    }
    
    // создает верхнюю кнопку выбора родительской Категории
    func setupTopChoseButton() {
        
        if categotyForUpdate == nil {
            topChooseButton
                .setTitle(NSLocalizedString("chooseParentButton", comment: ""),
                          for: .normal)
        } else {
            topChooseButton.setTitle(categotyForUpdate?.parent?.name, for: .normal)
        }
        
        viewOnScroll.addSubview(topChooseButton)
        
        topChooseButton.centerXAnchor.constraint(equalTo: viewOnScroll.centerXAnchor).isActive = true
        topChooseButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor, multiplier: 2 / 3).isActive = true
        topChooseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topChooseButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor,
                                                constant: -40).isActive = true
        
        topChooseButton.addTarget(self, action: #selector(tapTopChooseButton),
                                  for: .touchUpInside)        
    }
    
    // MARK: - Button's methods
    
    @objc override func tapCancelButton() {
        dismiss(animated: false, completion: nil)
    }
    
    // Проводит валидацию и сохраняет или вызывает подсказку
    @objc override func tapSaveButton() {
        
        guard let nameText = nameTextField.text else {
            assertionFailure()
            return
        }
        
        let checkRule = NameTextFieldValidate(text: nameText).validate()
        
        if checkRule.isEmpty {
            
            let message = MessageManager()
                .craftCategoryMessage(nameCategory: nameText,
                                      type: typeCategory,
                                      parent: topChooseButton.titleLabel?.text,
                                      id: categotyForUpdate?.id)
            
                dataProvider?.save(message: message)

            dismiss(animated: true, completion: nil)
            
        } else {
            
            for (_, value) in checkRule {
                showPromptView(with: value)
                addRedBorderTo(control: self.nameTextField)
                break
            }
            
        }
        
    }
    
    @objc func tapTopChooseButton() {
        
        guard let list = categories else {
            assertionFailure("Пустой массив с категориями!")
            return
        }
        
        ChooseCategoryAlert().show(categories: list,
                                   controller: self) { [weak self] (name) in
                                    self?.topChooseButton.setTitle(name, for: .normal)
        }
    }
    
    // MARK: - TextFields's methods
    
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
