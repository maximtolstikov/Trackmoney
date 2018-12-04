//swiftlint:disable sorted_imports
import XCTest
@testable import Trackmoney

class CreateControllersSpec: XCTestCase {
    
//    var accountsControllerBilder: AccountsControllerBuilder!
//    var mainTabBarControllerBilder: MainTabBarControllerBuilder!
//    var logControllerBilder: LogControllerBuilder!
//    var toolsControllerBilder: ToolsControllerBuilder!
//    var settingsControllerBilder: SettigsControllerBuilder!
//    var accountsSettingsControllerBilder: AccountsSettingsControllerBuilder: Builder!
//    var transactionFormControllerBilder: TransactionFormControllerBilder!
//    var accountFormControllerBilder: AccountFormControllerBilder!
//    
//    override func setUp() {
//        accountsControllerBilder = AccountsControllerBuilder()
//        mainTabBarControllerBilder = MainTabBarControllerBuilder()
//        logControllerBilder = LogControllerBuilder()
//        toolsControllerBilder = ToolsControllerBuilder()
//        settingsControllerBilder = SettigsControllerBuilder()
//        accountsSettingsControllerBilder = AccountsSettingsControllerBuilder: Builder()
//        transactionFormControllerBilder = TransactionFormControllerBilder()
//        accountFormControllerBilder = AccountFormControllerBilder()
//    }
//    override func tearDown() {
//        accountsControllerBilder = nil
//        mainTabBarControllerBilder = nil
//        logControllerBilder = nil
//        toolsControllerBilder = nil
//        settingsControllerBilder = nil
//        accountsSettingsControllerBilder = nil
//        transactionFormControllerBilder = nil
//        accountFormControllerBilder = nil
//    }
//    
//    func testCreateAccountController() throws {
//        
//        var accountController: AccountsController!
//        
//        try given("accountsController Bilder", closure: {
//            XCTAssertNotNil(accountsControllerBilder)
//        })
//        try when("create controller", closure: {
//            accountController = accountsControllerBilder
//                .viewController() as? AccountsController
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(accountController.dataLoader)
//        })
//        try then("dataLoader is AccountsDataLoader", closure: {
//            XCTAssertTrue(accountController.dataLoader is AccountsDataLoader)
//        })
//        try then("AccountDataLoder.dbManager is AccountsDBManager", closure: {
//            XCTAssertTrue(accountController.dataLoader?.dbManager is AccountDBManager)
//        })
//        
//        accountController = nil
//    }
//    
//    func testCreateLogController() throws {
//        
//        var logController: LogController!
//        
//        try given("logControllerBilder", closure: {
//            XCTAssertNotNil(logControllerBilder)
//        })
//        try when("create controller", closure: {
//            logController = logControllerBilder
//                .viewController() as? LogController
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(logController.dataProvider)
//        })
//        try then("LogDataLoder.dbManager is TransactionDBManager", closure: {
//            XCTAssertTrue(logController.dataProvider?.dbManager is TransactionDBManager)
//        })
//        
//        logController = nil
//        
//    }
//    
//    func testCreateToolsController() throws {
//        
//        var toolsController: ToolsController!
//        
//        try given("toolsControllerBilder", closure: {
//            XCTAssertNotNil(toolsControllerBilder)
//        })
//        try when("create controller", closure: {
//            toolsController = toolsControllerBilder
//                .viewController() as? ToolsController
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(toolsController.dataLoader)
//        })
//        try then("ToolsDataLoder.dbManager is TransactionDBManager", closure: {
//            XCTAssertTrue(toolsController.dataLoader?.dbManager is TransactionDBManager)
//        })
//        
//        toolsController = nil
//    }
//    
//    func testCreateMainTabBarController() throws {
//        
//        var mainTabBarController: MainTabBarController!
//        
//        try given("mainTabBarController Bilder", closure: {
//            XCTAssertNotNil(mainTabBarControllerBilder)
//        })
//        try when("create controller", closure: {
//            mainTabBarController = mainTabBarControllerBilder
//                .viewController() as? MainTabBarController
//        })
//        try then("tabBarController consist accountController with tag 0", closure: {
//            let navigationController = mainTabBarController.viewControllers![0] as! UINavigationController
//            let controller = navigationController.viewControllers.first
//            XCTAssertTrue(controller is AccountsController)
//        })
//        try then("tabBarController consist LogController with tag 1", closure: {
//            let navigationController = mainTabBarController.viewControllers![1] as! UINavigationController
//            let controller = navigationController.viewControllers.first
//            XCTAssertTrue(controller is LogController)
//        })
//        try then("tabBarController consist ToolsController with tag 2", closure: {
//            let navigationController = mainTabBarController.viewControllers![2] as! UINavigationController
//            let controller = navigationController.viewControllers.first
//            XCTAssertTrue(controller is ToolsController)
//        })
//        
//        mainTabBarController = nil
//    }
//    
//    func testCreateSettingsController() throws {
//        
//        var settingsController: SettingsController!
//        
//        try given("SettingsController Bilder", closure: {
//            XCTAssertNotNil(settingsControllerBilder)
//        })
//        try when("create controller", closure: {
//            settingsController = settingsControllerBilder
//                .viewController() as? SettingsController
//        })
//        try then("controller is not nil", closure: {
//            XCTAssertNotNil(settingsController)
//        })
//        try then("arrayPoint is not empty", closure: {
//            XCTAssertFalse(settingsController.arrayPoint.isEmpty)
//        })
//        
//        settingsController = nil
//        
//    }
//    
//    func testCreateAccountsSettingsController() throws {
//        
//        var accountsSettingsController: AccountsSettingsController!
//        
//        try given("AccountSettingsController Bilder", closure: {
//            XCTAssertNotNil(accountsSettingsControllerBilder)
//        })
//        try when("create controller", closure: {
//            accountsSettingsController = accountsSettingsControllerBilder
//                .viewController() as? AccountsSettingsController
//        })
//        try then("controller is not nil", closure: {
//            XCTAssertNotNil(accountsSettingsController)
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(accountsSettingsController.dataProvider)
//        })
//        try then("dataProvider is AccountsDataLoader", closure: {
//            XCTAssertTrue(accountsSettingsController
//                .dataProvider is AccountsSettingsDataProvider)
//        })
//        try then("AccountDataLoder.dbManager is AccountsDBManager", closure: {
//            XCTAssertTrue(accountsSettingsController.dataProvider?.dbManager is AccountDBManager)
//        })
//        
//        accountsSettingsController = nil
//        
//    }
//    
//    func testCreateTransactionFormController() throws {
//        
//        var transactionFormController: TransactionFormController!
//        
//        try given("TransactionFormController Bilder", closure: {
//            XCTAssertNotNil(transactionFormControllerBilder)
//        })
//        try when("create controller", closure: {
//            transactionFormController = transactionFormControllerBilder
//                .viewController(transactionType: TransactionType.expense)
//        })
//        try then("controller is not nil", closure: {
//            XCTAssertNotNil(transactionFormController)
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(transactionFormController.dataProvider)
//        })
//        try then("dataProvider is TransactionFormDataProvider", closure: {
//            XCTAssertTrue(transactionFormController
//                .dataProvider is TransactionFormDataProvider)
//        })
//        try then("TransactionFormDataProvider.dbManager is TransactionDBManager", closure: {
//            XCTAssertTrue(transactionFormController.dataProvider?.dbManager is TransactionDBManager)
//        })
//        
//        transactionFormController = nil
//        
//    }
//    
//    func testCreateAccountFormController() throws {
//        
//        var accountFormController: AccountFormController!
//        
//        try given("AccountFormController Bilder", closure: {
//            XCTAssertNotNil(transactionFormControllerBilder)
//        })
//        try when("create controller", closure: {
//            accountFormController = accountFormControllerBilder.viewController()
//        })
//        try then("controller is not nil", closure: {
//            XCTAssertNotNil(accountFormController)
//        })
//        try then("dataLoader is not nil", closure: {
//            XCTAssertNotNil(accountFormController.dataProvider)
//        })
//        try then("dataProvider is AccountFormDataProvider", closure: {
//            XCTAssertTrue(accountFormController
//                .dataProvider is AccountFormDataProvider)
//        })
//        try then("AccountFormDataProvider.dbManager is AccountsDBManager", closure: {
//            XCTAssertTrue(accountFormController.dataProvider?.dbManager is AccountDBManager)
//        })
//        
//        accountFormController = nil
//        
//    }
    
}
