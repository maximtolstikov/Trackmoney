// Для определения списка настроек

import UIKit

enum SettingListType: String, CaseIterable {
    
    case accountsSetting = "accountSettingsTitle"
    case categoriesSettings = "categoriSettingsTitile"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title: SettingListType) -> String {
        return title.localizedString()
    }
    
}
