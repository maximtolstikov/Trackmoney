//
//  SettingsList.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

/// Определяет список категорий настройки
enum SettingsList: String, CaseIterable {
    
    case entitiesSetting = "entytiesSettingsTitle"
    case repositorySettings = "categoriSettingsTitile"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title: SettingsList) -> String {
        return title.localizedString()
    }
    
}
