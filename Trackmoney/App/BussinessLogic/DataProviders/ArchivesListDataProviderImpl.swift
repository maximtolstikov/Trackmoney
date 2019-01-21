//
//  ArchivesListDataProvider.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import UIKit

class ArchivesListDataProviderImpl: ArchivesListDataProvider {
    
    let csvManager: CSVManager
    weak var controller: ArchivesListController?
    
    required init(manager: CSVManager) {
        self.csvManager = manager
    }
    
    func load() {
        guard let list = csvManager.archivesList() else { return }
        controller?.archives = list
    }
    
    func delete(_ list: [String]) {
        csvManager.deleteItems(list) {
            self.load()
        }
    }
    
    
}
