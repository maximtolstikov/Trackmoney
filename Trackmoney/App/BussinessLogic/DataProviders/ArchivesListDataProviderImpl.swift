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
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            guard let list = self.csvManager.archivesList() else { return }
            DispatchQueue.main.async {
                self.controller?.archives = list
            }
        }        
    }
    
    func delete(_ list: [String]) {
        csvManager.deleteItems(list) {
            self.load()
        }
    }
    
    
}
