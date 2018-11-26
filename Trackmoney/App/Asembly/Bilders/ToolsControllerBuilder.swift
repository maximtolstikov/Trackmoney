// Для описания строителя контроллера Интструменты

import UIKit

class ToolsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let toolsController = ToolsController()
        let dataLoader = ToolsDataLoader()
        dataLoader.dbManager = TransactionDBManager()
        dataLoader.controller = toolsController
        toolsController.dataLoader = dataLoader
        toolsController.title = "Tools"
        toolsController.tabBarItem = UITabBarItem(
            title: "Tools",
            image: UIImage(named: "Tools"),
            tag: 2)
        
        return toolsController
    }
    
}
