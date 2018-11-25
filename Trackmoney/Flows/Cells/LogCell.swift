// Для настройки ячейки журнала

import UIKit

class LogCell: UITableViewCell {
    
    var accountNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var sumLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var categoryNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var dateLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(accountNameLable)
        contentView.addSubview(sumLable)
        contentView.addSubview(categoryNameLable)
        contentView.addSubview(dateLable)
        
        createAccountNameLable()
        createSumLable()
        createCategoryNameLable()
        createDateLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAccountNameLable() {
        
        accountNameLable.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: 8).isActive = true
        accountNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        accountNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func createSumLable() {
        
        sumLable.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: 8).isActive = true
        sumLable.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                        multiplier: 1 / 4).isActive = true
        sumLable.rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -20).isActive = true
    }
    
    private func createCategoryNameLable() {
        
        categoryNameLable.topAnchor.constraint(equalTo: accountNameLable.bottomAnchor,
                                               constant: 2).isActive = true
        categoryNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        categoryNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 1 / 2).isActive = true
        
        createDateLable()
    }
    
    private func createDateLable() {
        
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
