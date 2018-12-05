import UIKit

class ToolsController: UIViewController {
    
    var tableView = UITableView()
    let cellIndentifire = "cell"
    var period: Period = .month
    var categories: [AverageCategory]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
        setupSegmentedControll()
        addTable()
        setupSwipeRight()
        setupSwipeLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            self.dataProvider?.load(self.period, .current)
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
    
    private func addTable() {
        
        let frame = CGRect.zero
        tableView = UITableView(frame: frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToolsCell.self, forCellReuseIdentifier: cellIndentifire)
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor,
                                       constant: 8.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // Обрабатывает нажатие на сегменты
    @objc func changeSegment(controll: UISegmentedControl) {
        if controll == self.segmentedControll {
            let index = controll.selectedSegmentIndex
            
            switch index {
            case 0:
                period = .month
                dataProvider?.load(period, .current)
            case 1:
                period = .year
                dataProvider?.load(period, .current)
            case 2:
                break
                // FIXMY: - реализовать DatePicker
//                let picker = UIDatePicker()
//                self.view.addSubview(picker)
//                picker.center = self.view.center
//                picker.datePickerMode = .countDownTimer
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
            dataProvider?.load(period, .next)
        case .right:
            dataProvider?.load(period, .previous)
            
        default:
            break
        }
    }

}

extension ToolsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: cellIndentifire,
                                 for: indexPath)
        
        cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        let cell = cell as! ToolsCell

        guard let category = categories?[indexPath.row] else { return }

        cell.categoryNameLable.text = category.name
        cell.sumLable.text = String(category.sum)
    }
    

}
