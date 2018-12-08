import UIKit

class AccountsControllerBuilder {
    
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
        let customSort = CustomSortManager(.accounts)
        accountsController.sortManager = customSort        
        
        return accountsController
    }
}
