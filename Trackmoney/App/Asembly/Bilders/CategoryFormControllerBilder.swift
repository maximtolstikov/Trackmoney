/// Строит контроллер формы Категории
class CategoryFormControllerBilder {
    
    let type: CategoryType
    
    init(typeCategory: CategoryType) {
        self.type = typeCategory
    }
    
    func viewController() -> CategoryFormController {
        
        let controller = CategoryFormController()
        let dataProvider = CategoryFormDataProvider()
        dataProvider.dbManager = CategoryDBManager()
        dataProvider.controller = controller
        controller.dataProvider = dataProvider
        controller.typeCategory = type
        
        return controller
    }
    
}
