import UIKit

class LogControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let logController = LogController()
        let dataLoader = LogDataLoader()
        dataLoader.dbManager = TransactionDBManager()
        dataLoader.controller = logController
        logController.dataProvider = dataLoader
        logController.title = "Log"
        logController.tabBarItem = UITabBarItem(
            title: "Log",
            image: UIImage(named: "Log"),
            tag: 1)
        
        return logController
        
    }
    
}
