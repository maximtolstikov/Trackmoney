import UIKit

class BaseFormController: UIViewController {
    
    // MARK: - Public properties
    
    var scrollView = UIScrollView()
    var viewOnScroll = UIView()
    let saveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(NSLocalizedString("saveTitle", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private properties
    
    private var promptView: UIView!
    private var tapOnViewGesture: UITapGestureRecognizer!
    
    private var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(NSLocalizedString("cancelTitle", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        createScrollView()
        createViewOnScroll()
        createSaveCancelButtons()
        registerForKeyboardNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure controller
    
    //создаем скролл
    func createScrollView() {
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.contentSize = self.view.bounds.size
        self.view.addSubview(self.scrollView)        
    }
    
    //создаем вью на скролл куда добавим все видимые элементы экрана
    func createViewOnScroll() {
        
        viewOnScroll = UIView(frame: self.view.bounds)
        viewOnScroll.backgroundColor = UIColor.white
        self.scrollView.addSubview(viewOnScroll)
    }
    
    //создаем кнопки Сохранит данные формы и Отменить
    func createSaveCancelButtons() {
        
        viewOnScroll.addSubview(cancelButton)
        viewOnScroll.addSubview(saveButton)
        
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.leftAnchor.constraint(equalTo: viewOnScroll.leftAnchor)
            .isActive = true
        cancelButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                            multiplier: 1 / 2).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: viewOnScroll.bottomAnchor,
                                             constant: -40).isActive = true
        cancelButton.addTarget(self, action: #selector(tapCancelButton),
                               for: .touchUpInside)
        
        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveButton.rightAnchor.constraint(equalTo: viewOnScroll.rightAnchor)
            .isActive = true
        saveButton.widthAnchor.constraint(equalTo: viewOnScroll.widthAnchor,
                                          multiplier: 1 / 2).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: viewOnScroll.bottomAnchor,
                                           constant: -40).isActive = true
        saveButton.addTarget(self, action: #selector(tapSaveButton),
                             for: .touchUpInside)
    }
    
    // Методы кнопок "сохранить" и "отменить"
    @objc func tapCancelButton() {}
    
    @objc func tapSaveButton() {}
    
    // MARK: - Private methods
    
    // MARK: - методы управления сдвигом при появлении клавиатуры
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(responseTextField),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeText),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            assertionFailure()
            return
        }
        
        //swiftlint:disable next force_cast
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue)
            .cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    
    // MARK: - методы уведомления TextField
    
    @objc func responseTextField(_ notification: Notification) {}
    
    @objc func didChangeText(_ notification: Notification) {}
    
    //показывает вью с подсказкой
    func showPromptView(with text: String) {
        
        if !(promptView is PromptView) {
            
            promptView = PromptView(for: self.view, with: text)
            animateSlideDownPromt(view: promptView)
        }
    }
    
    //уничтожает вью с подсказкой
    private func destroyPromptView() {
        promptView.removeFromSuperview()
        promptView = nil
    }
    
    //создаем жест тап по экрану
    private func tapOnScreen() {
        
        tapOnViewGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector (animateSlideUpPromt))
        tapOnViewGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapOnViewGesture)
        
    }
    
    // MARK: - Prompt View
    
    //анимирует вью с подсказкой вниз
    private func animateSlideDownPromt(view: UIView) {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.promptView.frame.origin.y = 0
        },
                       completion: { [weak self] (finish) in
                        self!.tapOnScreen()
        })
        
    }
    
    //анимирует вью с подсказкой вверх
    @objc func animateSlideUpPromt(completion: (() -> Void)?) {
        
        if promptView != nil {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.promptView.frame.origin.y = -100
            },
                           completion: { [weak self] (finish) in
                            self?.view.removeGestureRecognizer(self!.tapOnViewGesture)
                            if let gestures = self?.view.gestureRecognizers,
                                gestures.isEmpty {
                                self?.destroyPromptView()
                            }
            })
        }
    }
    
    // MARK: - Public methods
    
    //добавляет красную рамку вокруг textField
    func addRedBorderTo(control: UIControl) {
        control.layer.borderWidth = 2
        control.layer.borderColor = UIColor.red.cgColor
    }
    
    //удаляет красную рамку вокруг textField
    func removeRedBorderTo(control: UIControl) {
        control.layer.borderWidth = 0
        control.layer.borderColor = UIColor.white.cgColor
    }
}
