//
//  ArchivesListDataProvider.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

protocol ArchivesListDataProvider {
    
    var csvManager: CSVManager { get }
    
    init(manager: CSVManager)
    
    func load()
    func delete(_ list: [String])
}
