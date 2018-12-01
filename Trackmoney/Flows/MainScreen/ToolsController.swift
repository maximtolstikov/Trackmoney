import UIKit

class ToolsController: UIViewController {
    
    let segmentedControll: UISegmentedControl = {
        let array = [NSLocalizedString("monthSegment", comment: ""),
                     NSLocalizedString("yearSegment", comment: ""),
                     NSLocalizedString("periodSegment", comment: "")]
        let controll = UISegmentedControl(items: array)
        controll.translatesAutoresizingMaskIntoConstraints = false
        return controll
    }()
    
    let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dataLoader: DataProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingsButton()
        setupBackgroundView()
        setupScrollView()
        setupSegmentedControll()
        setupSwipeRight()
        setupSwipeLeft()
    }
    
    func setupBackgroundView() {
        
        self.view.addSubview(background)
        
        background.backgroundColor = UIColor(red: CGFloat(129) / 225.0,
                                                 green: CGFloat(121) / 225.0,
                                                 blue: CGFloat(198) / 225.0,
                                                 alpha: CGFloat(0.2))
        
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            .isActive = true
        background.topAnchor.constraint(equalTo: self.view.topAnchor)
            .isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            .isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            .isActive = true
    }
    
    func setupScrollView() {
        
        background.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: background.leftAnchor)
            .isActive = true
        scrollView.topAnchor.constraint(equalTo: background.topAnchor)
            .isActive = true
        scrollView.rightAnchor.constraint(equalTo: background.rightAnchor)
            .isActive = true
        scrollView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
            .isActive = true
    }
    
    func setupSegmentedControll() {
        
        segmentedControll.frame = CGRect.zero
        self.view.addSubview(segmentedControll)
        
        segmentedControll.layer.shadowOffset = CGSize(width: 0, height: 1)
        segmentedControll.layer.shadowOpacity = 1
        segmentedControll.layer.shadowRadius = 2
        
        var topHeight: CGFloat {
            return StatusBarType.check() ? 96.0 : 72.0
        }
        
        segmentedControll.selectedSegmentIndex = 0
        
        segmentedControll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
        segmentedControll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topHeight).isActive = true
        segmentedControll.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -16.0).isActive = true
        segmentedControll.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    // Устанавливает кнопку настроеек сверху справа
    private func setSettingsButton() {
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(named: "Settings"),
            style: .done,
            target: self,
            action: #selector(tapSettingsButton))
        self.navigationItem.rightBarButtonItem = settingsButton        
    }
    
    @objc func tapSettingsButton() {
        
        let settingsController = UINavigationController(
            rootViewController: SettigsControllerBuilder().viewController())
        present(settingsController, animated: true, completion: nil)
    }
    
    // MARK: - Gesture
    
    func setupSwipeLeft() {
        
        let gestre = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipes(_ :)))
        gestre.direction = .left
        self.view.addGestureRecognizer(gestre)
    }
    
    func setupSwipeRight() {
        
        let gestre = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipes(_ :)))
        gestre.direction = .right
        self.view.addGestureRecognizer(gestre)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        let countSegments = segmentedControll.numberOfSegments
        
        switch sender.direction {
        case .left:
            if segmentedControll.selectedSegmentIndex < countSegments - 1 {
                segmentedControll.selectedSegmentIndex += 1
            }
        case .right:
            if segmentedControll.selectedSegmentIndex > 0 {
                segmentedControll.selectedSegmentIndex -= 1
            }
        default:
            break
        }
    }

}
