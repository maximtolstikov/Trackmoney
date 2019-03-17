import UIKit

/// Ячейка таблицы журнала
class LogCell: UITableViewCell {
    
    // MARK: - Constants
    
    let dateFormat = DateFormat()

    // MARK: - Identifiers
    
    static let reuseId = "LogCell"
    
    // MARK: - Public properties
    
    var sumLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private properties
    
    private var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat(11) / 225.0,
                                       green: CGFloat(154) / 225.0,
                                       blue: CGFloat(117) / 225.0,
                                       alpha: CGFloat(0.1))
        view.layer.cornerRadius = 8.0
        view.layer.borderColor = UIColor(red: CGFloat(11) / 225.0,
                                         green: CGFloat(154) / 225.0,
                                         blue: CGFloat(117) / 225.0,
                                         alpha: CGFloat(1.0)).cgColor
        view.layer.borderWidth = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var typeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var accountNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addElements()
        setupConstaints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(transaction: Transaction) {
        
        let date = transaction.date as Date
        let stringFromDate = dateFormat.dateFormatter.string(from: date)
        
        accountNameLable.text = transaction.mainAccount
        sumLable.text = sumLableText(sum: String(transaction.sum), note: transaction.note)
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
    
    private func sumLableText(sum: String, note: String?) -> String {
        if note != nil && note != "" { return "📝 " + sum }
        return sum
    }
    
    private func addElements() {
        contentView.addSubview(background)
        background.addSubview(typeImage)
        background.addSubview(accountNameLable)
        background.addSubview(categoryNameLable)
        background.addSubview(sumLable)
        background.addSubview(dateLable)
    }
    
    private func setupConstaints() {
    
        // backgroundView
        background.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        background.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -4).isActive = true
        
        // typeImage
        typeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        typeImage.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        typeImage.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 8).isActive = true
        
        // accountNameLable
        accountNameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        accountNameLable.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 8).isActive = true
        accountNameLable.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 2 / 3).isActive = true
        
        // sumLable
        sumLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        sumLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 4).isActive = true
        sumLable.leftAnchor.constraint(equalTo: accountNameLable.rightAnchor).isActive = true
        sumLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        
        // categoryNameLable
        categoryNameLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor, constant: 2).isActive = true
        categoryNameLable.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 8).isActive = true
        categoryNameLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 2).isActive = true

        // dateLable
        dateLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor, constant: 2).isActive = true
        dateLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        dateLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 2).isActive = true
    }

}
