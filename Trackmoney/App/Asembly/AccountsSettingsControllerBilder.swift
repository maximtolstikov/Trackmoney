// Для строительства контроллера "Настроек Счетов"

import UIKit

class AccountsSettingsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let accountsSettingsController = AccountsSettingsController()
        let dataProvider = AccountsSettingsDataProvider()
        dataProvider.dbManager = AccountDBManager()
        dataProvider.controller = accountsSettingsController
        accountsSettingsController.dataProvider = dataProvider        
        accountsSettingsController
            .navigationItem.title = NSLocalizedString("settingsAccounts",
                                                      comment: "")
        let customSort = CustomSortManager(.accounts)
        accountsSettingsController.sortManager = customSort
        
        return accountsSettingsController
        
    }
    
}
