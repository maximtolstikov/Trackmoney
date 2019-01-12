import UIKit

class AccountsCell: UITableViewCell {
    
    var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var accountNameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var sumLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(background)
        background.addSubview(accountNameLable)
        background.addSubview(sumLable)
        
        setupBackgroundView()
        setupNameLable()
        setupSumLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundView() {
        
        background.backgroundColor = UIColor(red: CGFloat(11) / 225.0,
                                             green: CGFloat(154) / 225.0,
                                             blue: CGFloat(117) / 225.0,
                                             alpha: CGFloat(0.4))
        background.layer.cornerRadius = 20.0
        background.layer.borderColor = UIColor(red: CGFloat(102) / 225.0,
                                               green: CGFloat(218) / 225.0,
                                               blue: CGFloat(181) / 225.0,
                                               alpha: CGFloat(1.0)).cgColor
        background.layer.borderWidth = 2
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 4
        
        background.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        background.leftAnchor
            .constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor
            .constraint(equalTo: contentView.rightAnchor).isActive = true
        background.heightAnchor
            .constraint(equalTo: contentView.heightAnchor,
                        constant: -8).isActive = true
    }
    
    private func setupNameLable() {
        
        accountNameLable.font = UIFont.boldSystemFont(ofSize: 24)
        accountNameLable.textColor = UIColor.white
        accountNameLable.adjustsFontSizeToFitWidth = true
        
        accountNameLable.centerYAnchor
            .constraint(equalTo: background.centerYAnchor).isActive = true
        accountNameLable.leftAnchor
            .constraint(equalTo: background.leftAnchor,
                        constant: 20).isActive = true
        accountNameLable.widthAnchor
            .constraint(equalTo: background.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func setupSumLable() {
        
        sumLable.font = UIFont.boldSystemFont(ofSize: 24)
        sumLable.textColor = UIColor.white
        sumLable.textAlignment = .right
        sumLable.adjustsFontSizeToFitWidth = true
        
        sumLable.centerYAnchor
            .constraint(equalTo: background.centerYAnchor).isActive = true
        sumLable.widthAnchor.constraint(equalTo: background.widthAnchor,
                                        multiplier: 1 / 4).isActive = true
        sumLable.rightAnchor
            .constraint(equalTo: background.rightAnchor,
                        constant: -20).isActive = true
    }
    
}
