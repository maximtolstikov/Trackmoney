import UIKit

/// Ячейка таблицы журнала
class LogCell: UITableViewCell {
    
    // MARK: - Constants
    
    let dateFormat = DateFormat()

    // MARK: - Identifiers
    
    static let reuseId = "LogCell"
    
    // MARK: - Public properties
    
    var sumLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    // MARK: - Private properties
    
    private var typeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var accountNameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    private var categoryNameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    private var dateLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackgroundView()
        setupTypeImage()
        setupAccountNameLable()
        setupSumLable()
        setupCategoryNameLable()
        setupDateLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(transaction: Transaction) {
        
        let date = transaction.date as Date
        let stringFromDate = dateFormat.dateFormatter.string(from: date)
        
        accountNameLable.text = transaction.mainAccount
        sumLable.text = String(transaction.sum)
        dateLable.text = stringFromDate
        typeImage.image = UIImage(named: transaction.icon)
        
        let type = transaction.type
        switch type {
        case 0:
            sumLable.textColor = #colorLiteral(red: 0.7835699556, green: 0.2945081919, blue: 0.07579417304, alpha: 1)
            categoryNameLable.text = transaction.category
        case 1:
            sumLable.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            categoryNameLable.text = transaction.category
        case 2:
            sumLable.textColor = UIColor.darkGray
            categoryNameLable.text = "\(transaction.mainAccount)"
                + "/" + "\(String(describing: transaction.corAccount ?? ""))"
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func setupBackgroundView() {
        contentView.addSubview(background)
        background.backgroundColor = UIColor(red: CGFloat(11) / 225.0,
                                             green: CGFloat(154) / 225.0,
                                             blue: CGFloat(117) / 225.0,
                                             alpha: CGFloat(0.1))
        background.layer.cornerRadius = 8.0
        background.layer.borderColor = UIColor(red: CGFloat(11) / 225.0,
                                               green: CGFloat(154) / 225.0,
                                               blue: CGFloat(117) / 225.0,
                                               alpha: CGFloat(1.0)).cgColor
        background.layer.borderWidth = 2
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 3
        
        background.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        background.leftAnchor
            .constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor
            .constraint(equalTo: contentView.rightAnchor).isActive = true
        background.heightAnchor
            .constraint(equalTo: contentView.heightAnchor,
                        constant: -4).isActive = true
    }
    
    private func setupTypeImage() {
        background.addSubview(typeImage)
        typeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        typeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        typeImage.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: 8).isActive = true
    }
    
    private func setupAccountNameLable() {
        background.addSubview(accountNameLable)
        accountNameLable.font = UIFont.systemFont(ofSize: 18)
        
        accountNameLable.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: 10).isActive = true
        accountNameLable.leftAnchor
            .constraint(equalTo: typeImage.rightAnchor,
                        constant: 8).isActive = true
        accountNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func setupSumLable() {
        background.addSubview(sumLable)
        sumLable.font = UIFont.systemFont(ofSize: 18)
        sumLable.textAlignment = .right
        
        sumLable.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: 10).isActive = true
        sumLable.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                        multiplier: 1 / 4).isActive = true
        sumLable.rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -20).isActive = true
    }
    
    private func setupCategoryNameLable() {
        background.addSubview(categoryNameLable)
        categoryNameLable.font = UIFont.systemFont(ofSize: 14)
        categoryNameLable.textColor = UIColor.gray
        
        categoryNameLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor,
                                               constant: 2).isActive = true
        categoryNameLable.leftAnchor
            .constraint(equalTo: typeImage.rightAnchor,
                        constant: 8).isActive = true
        categoryNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 1 / 2).isActive = true
    }
    
    private func setupDateLable() {
        background.addSubview(dateLable)
        dateLable.font = UIFont.italicSystemFont(ofSize: 12)
        dateLable.textColor = UIColor.gray
        
        dateLable.textAlignment = .right
        dateLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor,
                                       constant: 2).isActive = true
        dateLable.rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -20).isActive = true
        dateLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 1 / 2).isActive = true
    }

}
