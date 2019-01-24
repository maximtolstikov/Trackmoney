import UIKit

class SettigsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let settingsController = SettingsController()
        let dataProvider = SettingsControllerDataProviderImpl()
        dataProvider.controller = settingsController
        settingsController.csvManager = CSVManagerImpl()
        settingsController.dataProvider = dataProvider
        settingsController.navigationItem
            .title = NSLocalizedString("settings", comment: "")
        
        return settingsController
    }
}
