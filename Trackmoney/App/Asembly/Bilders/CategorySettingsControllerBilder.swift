// Для строительства контроллера "Настроек Категорий"

import UIKit

class CategorySettingsControllerBilder {
    
    func viewController() -> UIViewController {
        
        let categorySettingsController = CategorySettingsController()
        let dataProvider = CategorySettingsDataProvider()
        dataProvider.dbManager = CategoryDBManager()
        dataProvider.controller = categorySettingsController
        categorySettingsController.dataProvider = dataProvider
        categorySettingsController
            .navigationItem.title = NSLocalizedString("settingsCategories",
                                                      comment: "")
        
        return categorySettingsController
        
    }
    
}
