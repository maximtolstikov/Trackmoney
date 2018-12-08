import UIKit

class AccountFormControllerBuilder {
    
    func viewController() -> AccountFormController {
        
        let controller = AccountFormController()
        let dataProvider = AccountFormDataProvider()
        dataProvider.dbManager = AccountDBManager()
        dataProvider.controller = controller
        controller.dataProvider = dataProvider
        
        return controller
    }
    
}
