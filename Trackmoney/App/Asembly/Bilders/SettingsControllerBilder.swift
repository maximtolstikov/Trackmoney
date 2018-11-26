// Для строительства контроллера выбора настроек

import UIKit

class SettigsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let settingsController = SettingsController()
        settingsController.navigationItem.title = "Settings"
        settingsController.arrayPoint = createSettingsList()
        
        return settingsController
        
    }
    
    private func createSettingsList() -> [String] {
        
        var array = [String]()
        
        for item in SettingListType.allCases {
            array.append(SettingListType.getTitleFor(title: item))
        }
        
        return array
        
    }
    
}
