// Для строительства контроллера "Настроек Категорий"

import UIKit

class CategorySettingsControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let categorySettingsController = CategorySettingsController()
        let dataProvider = CategorySettingsDataProvider()
        dataProvider.dbManager = CategoryDBManager()
        dataProvider.controller = categorySettingsController
        categorySettingsController.dataProvider = dataProvider
        categorySettingsController
            .navigationItem.title = NSLocalizedString("settingsCategories",
                                                      comment: "")
        let customSort = CustomSortManager(entity: CategoryTransaction.self)
        categorySettingsController.sortManager = customSort
        
        return categorySettingsController
        
    }
    
}
