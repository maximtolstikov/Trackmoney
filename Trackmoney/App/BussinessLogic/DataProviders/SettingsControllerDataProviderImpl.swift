//
//  SettingsControllerDataProviderImpl.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 24/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

class SettingsControllerDataProviderImpl: SettingsControllerDataProvider {
    
    weak var controller: SettingsController?
    
    func loadData() {
        
        controller?.categorySettings = createCategoryList()
        controller?.entitiesList = createSettingsList()
        controller?.archivesList = createRepositoryActionList()
    }
    
    private func createCategoryList() -> [String] {
        var array = [String]()
        for item in SettingsList.allCases {
            array.append(SettingsList.getTitleFor(title: item))
        }
        return array
    }
    
    private func createSettingsList() -> [String] {
        var array = [String]()
        for item in EntitiesList.allCases {
            array.append(EntitiesList.getTitleFor(title: item))
        }
        return array
    }
    
    private func createRepositoryActionList() -> [String] {
        var array = [String]()
        for item in Repository.allCases {
            array.append(Repository.getTitleFor(title: item))
        }
        return array
    }
}
