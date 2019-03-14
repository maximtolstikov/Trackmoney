// Для настройки вью подсказки

import UIKit

class PromptView: UIView {
    
    init(for view: UIView, with text: String) {
        super.init(frame: CGRect(x: 0,
                                 y: -100,
                                 width: view.frame.width,
                                 height: 100))
        
        self.backgroundColor = UIColor.purple
        
        let lable = UILabel(frame: CGRect(x: 0,
                                          y: self.frame.height - 50,
                                          width: self.frame.width,
                                          height: 30))
        lable.text = text
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(lable)
        
        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
