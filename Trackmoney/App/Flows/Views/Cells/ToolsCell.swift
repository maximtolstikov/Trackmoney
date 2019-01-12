import UIKit

class ToolsCell: UITableViewCell {
    
    var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
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
   
        setupBackgroundView()
        setupNameLable()
        setupSumLable()
        setIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundView() {
        
        contentView.addSubview(background)
        
        background.backgroundColor = UIColor(red: CGFloat(11) / 225.0,
                                             green: CGFloat(154) / 225.0,
                                             blue: CGFloat(117) / 225.0,
                                             alpha: CGFloat(0.1))
        
        background.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 3
        
        background.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        background.leftAnchor
            .constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor
            .constraint(equalTo: contentView.rightAnchor).isActive = true
        background.heightAnchor
            .constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    private func setupNameLable() {
        
        background.addSubview(categoryNameLable)
        categoryNameLable.font = UIFont.italicSystemFont(ofSize: 16)
        categoryNameLable.adjustsFontSizeToFitWidth = true
        
        categoryNameLable.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        categoryNameLable.leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: 20).isActive = true
        categoryNameLable.widthAnchor
            .constraint(equalTo: contentView.widthAnchor,
                        multiplier: 2 / 3).isActive = true
    }
    
    private func setupSumLable() {
        
        background.addSubview(sumLable)
        sumLable.textAlignment = .right
        sumLable.adjustsFontSizeToFitWidth = true
        
        sumLable.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        sumLable.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                        multiplier: 1 / 4).isActive = true
        sumLable.rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -20).isActive = true
    }
    
    private func setIndicator() {
        
        background.layer.addSublayer(shapeLayer)
        
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = nil
        shapeLayer.strokeEnd = 1
        shapeLayer.frame = contentView.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.bounds.minX + 16.0,
                              y: contentView.bounds.maxY - 10.0))
        path.addLine(to: CGPoint(x: contentView.bounds.maxX - 16.0,
                                 y: contentView.bounds.maxY - 10.0))
        shapeLayer.path = path.cgPath
        
    }
    
}
