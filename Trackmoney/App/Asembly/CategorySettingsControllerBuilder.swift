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
        let expenseSort = CustomSortManager(.expense)
        let incomeSort = CustomSortManager(.income)
        categorySettingsController.incomeSortManager = incomeSort
        categorySettingsController.expenseSortManager = expenseSort
        
        return categorySettingsController
        
    }
    
}
