import UIKit

class ToolsCell: UITableViewCell {
    
    var categoryNameLable: UILabel = {
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
        
        contentView.addSubview(categoryNameLable)
        contentView.addSubview(sumLable)
        
        setupNameLable()
        setupSumLable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNameLable() {
        
        categoryNameLable.font = UIFont.boldSystemFont(ofSize: 24)
        categoryNameLable.textColor = UIColor.white
        categoryNameLable.adjustsFontSizeToFitWidth = true
        
        categoryNameLable.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        categoryNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func setupSumLable() {
        
        sumLable.font = UIFont.boldSystemFont(ofSize: 24)
        sumLable.textColor = UIColor.white
        sumLable.textAlignment = .right
        sumLable.adjustsFontSizeToFitWidth = true
        
        sumLable.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        sumLable.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                        multiplier: 1 / 4).isActive = true
        sumLable.rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -20).isActive = true
    }
    
}
