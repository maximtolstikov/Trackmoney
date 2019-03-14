import UIKit

class ToolsController: UIViewController {
    
    var tableView = UITableView()
    let cellIndentifire = "cell"
    var period: Period = .month
    
    var expenseCategories: [AverageCategory]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var incomeCategories: [AverageCategory]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let segmentedControll: UISegmentedControl = {
        let array = [NSLocalizedString("monthSegment", comment: ""),
                     NSLocalizedString("yearSegment", comment: "")]
        let controll = UISegmentedControl(items: array)
        controll.translatesAutoresizingMaskIntoConstraints = false
        return controll
    }()
    
    var dataProvider: ToolsDataProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
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
        
        var topHeight: CGFloat {
            return StatusBarType.check() ? 96.0 : 72.0
        }
        
        segmentedControll.selectedSegmentIndex = 0
        
        segmentedControll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
        segmentedControll.topAnchor.constraint(equalTo: self.view.topAnchor,
                                               constant: topHeight).isActive = true
        segmentedControll.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                                 constant: -16.0).isActive = true
        segmentedControll.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    }
    
    private func addTable() {
        
        let frame = CGRect.zero
        tableView = UITableView(frame: frame, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.register(ToolsCell.self, forCellReuseIdentifier: cellIndentifire)
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor,
                                       constant: 1.0).isActive = true
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ToolsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return expenseCategories?.count ?? 0
        } else {
            return incomeCategories?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire,
                                                 for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        // swiftlint:disable next force_cast
        let cell = cell as! ToolsCell
        
        if indexPath.section == 0 {
            
            guard let category = expenseCategories?[indexPath.row] else { return }
            
            cell.categoryNameLable.text = category.name
            cell.sumLable.text = String(category.sum)
            cell.shapeLayer.strokeEnd = CGFloat(category.part)
            cell.shapeLayer.strokeColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            
        } else {
            
            guard let category = incomeCategories?[indexPath.row] else { return }
            
            cell.categoryNameLable.text = category.name
            cell.sumLable.text = String(category.sum)
            cell.shapeLayer.strokeEnd = CGFloat(category.part)
            cell.shapeLayer.strokeColor = #colorLiteral(red: 0.1855610516, green: 0.495716603, blue: 0.9686274529, alpha: 1)
        }
    }
    
}
