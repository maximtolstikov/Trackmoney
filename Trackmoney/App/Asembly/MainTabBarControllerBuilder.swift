import UIKit

class MainTabBarControllerBuilder {
      
    func viewController() -> UIViewController {
        
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = createControllers()
            .map { UINavigationController(rootViewController: $0) }
        
        return tabBarController
    }
    
    
    // Создаем контроллеры для TabBarController
    private func createControllers() -> [UIViewController] {
        
        let accountsController = AccountsControllerBuilder().viewController()
        let logController = LogControllerBuilder().viewController()
        let toolsController = ToolsControllerBuilder().viewController()
        
        return [accountsController, logController, toolsController]
    }
}
