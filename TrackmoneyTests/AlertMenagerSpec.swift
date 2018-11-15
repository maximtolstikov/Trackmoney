// Для описания спецификации методов AlertManager

//swiftlint:disable sorted_imports

import XCTest
@testable import Trackmoney

class AlertManagerSpec: XCTestCase {
    
    var alertManager: AlertManager!
    
    override func setUp() {
        alertManager = AlertManager()
    }
    override func tearDown() {
        alertManager = nil
    }
    
    func testShortNotification() throws {
        
        var controller: UIViewController!
        
        try given("controller", closure: {
            controller = UIViewController()
        })
        try when("appear notif", closure: {
            alertManager.shortNotification(controller: controller, title: "test", body: nil, style: .alert)
        })
        try then("after 5 milliseconds alertController is nil", closure: {
            _ = Timer(timeInterval: 1.0, repeats: false, block: { _ in
                XCTAssertNil(self.alertManager.alertController)
            })
        })
        
    }
    
}
