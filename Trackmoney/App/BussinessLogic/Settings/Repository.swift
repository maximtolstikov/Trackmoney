//
//  RepositoryList.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

/// Определяет список настроек Архивирования
enum Repository: String, CaseIterable {
    
    case saveBase = "archivesTitle"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title: Repository) -> String {
        return title.localizedString()
    }
    
}
