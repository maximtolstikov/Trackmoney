// Строит контроллер формы Категории

class CategoryFormControllerBilder {
    
    func viewController() -> CategoryFormController {
        
        let controller = CategoryFormController()
        let dataProvider = CategoryFormDataProvider()
        dataProvider.dbManager = CategoryDBManager()
        dataProvider.controller = controller
        controller.dataProvider = dataProvider
        
        return controller
    }
    
}
