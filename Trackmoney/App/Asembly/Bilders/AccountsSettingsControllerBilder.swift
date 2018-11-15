// Для строительства контроллера "Настроек Счетов"

import UIKit

class AccountsSettingsControllerBilder {
    
    func viewController() -> UIViewController {
        
        let accountsSettingsController = AccountsSettingsController()
        let dataProvider = AccountsSettingsDataProvider()
        dataProvider.dbManager = AccountDBManager()
        dataProvider.controller = accountsSettingsController
        accountsSettingsController.dataProvider = dataProvider        
        accountsSettingsController
            .navigationItem.title = NSLocalizedString("settingsAccounts",
                                                      comment: "")
        return accountsSettingsController
        
    }
    
}
