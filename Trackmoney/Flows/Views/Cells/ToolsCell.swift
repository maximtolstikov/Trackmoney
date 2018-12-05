import UIKit

class ToolsCell: UITableViewCell {
    
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
   
        setupNameLable()
        setupSumLable()
        setIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNameLable() {
        
        contentView.addSubview(categoryNameLable)
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
        
        contentView.addSubview(sumLable)
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
        
        contentView.layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = nil
        shapeLayer.strokeEnd = 1
        shapeLayer.strokeColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        shapeLayer.frame = contentView.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.bounds.minX + 16.0,
                              y: contentView.bounds.maxY - 10.0))
        path.addLine(to: CGPoint(x: contentView.bounds.maxX - 16.0,
                                 y: contentView.bounds.maxY - 10.0))
        shapeLayer.path = path.cgPath
        
    }
    
}
