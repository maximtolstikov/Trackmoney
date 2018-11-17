// Для описания спецификации методов AlertManager

//swiftlint:disable sorted_imports

import XCTest
@testable import Trackmoney

class ShortAlertSpec: XCTestCase {
    
    var shortAlert: ShortAlert!
    
    override func setUp() {
        shortAlert = ShortAlert()
    }
    override func tearDown() {
        shortAlert = nil
    }
    
    func testShortNotification() throws {
        
        var controller: UIViewController!
        
        try given("controller", closure: {
            controller = UIViewController()
        })
        try when("appear notif", closure: {
            shortAlert.show(controller: controller, title: "test", body: nil, style: .alert)
        })
        try then("after 5 milliseconds alertController is nil", closure: {
            _ = Timer(timeInterval: 1.0, repeats: false, block: { _ in
                XCTAssertNil(self.shortAlert.alertController)
            })
        })
        
    }
    
}
