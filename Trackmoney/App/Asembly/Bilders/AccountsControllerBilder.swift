// Для конструирования контроллера счетов

import UIKit

class AccountsControllerBilder {
    
    func viewController() -> UIViewController {
        
        let accountsController = AccountsController()
        let dataLoader = AccountsDataLoader()
        dataLoader.dbManager = AccountDBManager()
        dataLoader.controller = accountsController
        accountsController.dataLoader = dataLoader
        accountsController.tabBarItem = UITabBarItem(
            title: "Accounts",
            image: UIImage(named: "Accounts"),
            tag: 0)
        
        
        return accountsController
    }
}
