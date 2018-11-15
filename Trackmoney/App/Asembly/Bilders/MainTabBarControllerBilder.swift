// Для конструирования Главного Таб бар контроллера

import UIKit

class MainTabBarControllerBilder {
      
    func viewController() -> UIViewController {
        
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = createControllers()
            .map { UINavigationController(rootViewController: $0) }
        
        return tabBarController
    }
    
    
    // Создаем контроллеры для TabBarController
    private func createControllers() -> [UIViewController] {
        
        let accountsController = AccountsControllerBilder().viewController()
        let logController = LogControllerBilder().viewController()
        let toolsController = ToolsControllerBilder().viewController()
        
        return [accountsController, logController, toolsController]
    }
}
