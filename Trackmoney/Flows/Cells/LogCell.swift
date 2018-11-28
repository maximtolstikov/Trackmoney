// Для настройки ячейки журнала

import UIKit

class LogCell: UITableViewCell {
    
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
    
    var categoryNameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var dateLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(background)
        background.addSubview(accountNameLable)
        background.addSubview(sumLable)
        background.addSubview(categoryNameLable)
        background.addSubview(dateLable)
        
        setupBackgroundView()
        setupAccountNameLable()
        setupSumLable()
        setupCategoryNameLable()
        setupDateLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundView() {
        
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
    
    private func setupAccountNameLable() {
        
        accountNameLable.font = UIFont.systemFont(ofSize: 18)
        
        accountNameLable.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: 10).isActive = true
        accountNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        accountNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func setupSumLable() {
        
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
        
        categoryNameLable.font = UIFont.systemFont(ofSize: 14)
        categoryNameLable.textColor = UIColor.gray
        
        categoryNameLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor,
                                               constant: 2).isActive = true
        categoryNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        categoryNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 1 / 2).isActive = true
    }
    
    private func setupDateLable() {
        
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
