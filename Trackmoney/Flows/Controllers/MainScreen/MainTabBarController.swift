// Для настройки MainTabBarViewController

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }
    
    func turnScreen(_ sender: UISwipeGestureRecognizer) {
        
        let direction = sender.direction
        
        switch direction {
        case .left:
            guard let numberScreen = viewControllers?.count else { return }
            if selectedIndex < numberScreen {
                selectedIndex += 1
            }
        case .right:
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        default:
            break
        }

    }

}
