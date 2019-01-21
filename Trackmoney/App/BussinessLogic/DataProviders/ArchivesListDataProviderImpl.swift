//
//  ArchivesListDataProvider.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

class ArchivesListDataProviderImpl: ArchivesListDataProvider {
    
    let csvManager: CSVManager
    
    required init(manager: CSVManager) {
        self.csvManager = manager
    }
    
    func load(completion: @escaping ([String]?) -> Void) {
        let list = csvManager.archivesList()
        completion(list)
    }
    
    func delete(_ list: [String]) {
        
    }
    
    
}
