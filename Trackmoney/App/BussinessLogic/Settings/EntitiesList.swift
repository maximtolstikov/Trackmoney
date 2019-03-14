import Foundation

/// Определяет список сущьностей для настройки
enum EntitiesList: String, CaseIterable {
    
    case accountsSetting = "accountSettingsTitle"
    case categoriesSettings = "categoriSettingsTitile"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title: EntitiesList) -> String {
        return title.localizedString()
    }
    
}
