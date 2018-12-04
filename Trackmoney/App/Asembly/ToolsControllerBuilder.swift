// Для описания строителя контроллера Интструменты

import UIKit

class ToolsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let toolsController = ToolsController()
        let dataProvider = ToolsDataProvider()
        let dateManager = DateManager()
        dataProvider.dataManager = TransactionDBManager()
        dataProvider.controller = toolsController
        dataProvider.dateManager = dateManager
        toolsController.dataProvider = dataProvider
        toolsController.title = "Tools"
        toolsController.tabBarItem = UITabBarItem(
            title: "Tools",
            image: UIImage(named: "Tools"),
            tag: 2)
        
        return toolsController
    }
    
}
