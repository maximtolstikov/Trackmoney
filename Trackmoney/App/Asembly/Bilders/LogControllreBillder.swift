// Для строительства контроллера журнала

import UIKit

class LogControllerBilder {
    
    func viewController() -> UIViewController {
        
        let logController = LogController()
        let dataLoader = LogDataLoader()
        dataLoader.dbManager = TransactionDBManager()
        dataLoader.controller = logController
        logController.dataLoader = dataLoader
        logController.title = "Log"
        logController.tabBarItem = UITabBarItem(
            title: "Log",
            image: UIImage(named: "Log"),
            tag: 1)
        
        return logController
        
    }
    
}
