import UIKit

class SettigsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let settingsController = SettingsController()
        settingsController.navigationItem
            .title = NSLocalizedString("settings", comment: "")
        settingsController.categorySettings = createCategoryList()
        settingsController.entitiesList = createSettingsList()
        settingsController.repositoryActions = createRepositoryActionList()
        
        return settingsController
    }
    
    private func createCategoryList() -> [String] {
        var array = [String]()
        for item in SettingsList.allCases {
            array.append(SettingsList.getTitleFor(title: item))
        }
        return array
    }
    
    private func createSettingsList() -> [String] {
        var array = [String]()
        for item in EntitiesList.allCases {
            array.append(EntitiesList.getTitleFor(title: item))
        }
        return array
    }
    
    private func createRepositoryActionList() -> [String] {
        var array = [String]()
        for item in RepositoryActionList.allCases {
            array.append(RepositoryActionList.getTitleFor(title: item))
        }
        return array
    }
    
}
