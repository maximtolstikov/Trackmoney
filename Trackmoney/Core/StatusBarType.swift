//swiftlint:disable comma
import UIKit

/// Проверяет новый или старый статус бар
class StatusBarType {
    
    static func check() -> Bool {
        
        if #available (iOS 11.0,  *) {
            return UIApplication.shared.delegate?
                .window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
