// Для строительства контроллера формы транзакции

class TransactionFormControllerBilder {
    
    func viewController(transactionType: TransactionType) -> TransactionFormController {
        
        let controller = TransactionFormController()
        let dataProvider = TransactionFormDataProvider()
        dataProvider.controller = controller
        
        switch transactionType {
        case .expense:
            dataProvider.dbManager = TransactionDBManager()
            dataProvider.accountDbManager = AccountDBManager()
            dataProvider.categoryDbManager = CategoryDBManager()
            controller.transactionType = TransactionType.expense
        case .income:
            dataProvider.dbManager = TransactionDBManager()
            dataProvider.accountDbManager = AccountDBManager()
            dataProvider.categoryDbManager = CategoryDBManager()
            controller.transactionType = TransactionType.income
        case .transfer:
            dataProvider.dbManager = TransactionDBManager()
            dataProvider.accountDbManager = AccountDBManager()
            controller.transactionType = TransactionType.transfer
        }
        
        controller.dataProvider = dataProvider
        
        return controller
        
    }
    
}
