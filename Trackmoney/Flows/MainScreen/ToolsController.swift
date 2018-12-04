import UIKit

class ToolsController: UIViewController {
    
    var period: Period = .month
    
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
    
    var dataProvider: ToolsDataProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingsButton()
        setupBackgroundView()
        setupScrollView()
        setupSegmentedControll()
        setupSwipeRight()
        setupSwipeLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.global().async {
            self.dataProvider?.load(self.period)
        }
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
        segmentedControll.addTarget(self,
                                    action: #selector(changeSegment),
                                    for: .valueChanged)
        self.view.addSubview(segmentedControll)
        
        segmentedControll.layer.shadowOffset = CGSize(width: 0, height: 1)
        segmentedControll.layer.shadowOpacity = 1
        segmentedControll.layer.shadowRadius = 3
        
        var topHeight: CGFloat {
            return StatusBarType.check() ? 96.0 : 72.0
        }
        
        segmentedControll.selectedSegmentIndex = 0
        
        segmentedControll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
        segmentedControll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topHeight).isActive = true
        segmentedControll.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -16.0).isActive = true
        segmentedControll.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    @objc func changeSegment(controll: UISegmentedControl) {
        if controll == self.segmentedControll {
            let index = controll.selectedSegmentIndex
            
            switch index {
            case 0:
                period = .month
                dataProvider?.load(period)
            case 1:
                period = .year
                dataProvider?.load(period)
            case 2:
                break
            default:
                break
            }
        }
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
        
        switch sender.direction {
        case .left:
            dataProvider?.next(period)
        case .right:
            dataProvider?.previous(period)
            
        default:
            break
        }
    }

}
