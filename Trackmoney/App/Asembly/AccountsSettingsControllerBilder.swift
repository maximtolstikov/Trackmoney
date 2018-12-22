import UIKit

class AccountsSettingsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let accountsSettingsController = AccountsSettingsController()
        let dataProvider = AccountsSettingsDataProvider()
        let formController = AccountFormControllerBuilder().viewController()
        dataProvider.dbManager = AccountDBManager()
        dataProvider.controller = accountsSettingsController
        accountsSettingsController.dataProvider = dataProvider        
        accountsSettingsController
            .navigationItem.title = NSLocalizedString("settingsAccounts",
                                                      comment: "")
        accountsSettingsController.formController = formController
        let customSort = CustomSortManager(.accounts)
        accountsSettingsController.sortManager = customSort
        
        return accountsSettingsController
        
    }
    
}
