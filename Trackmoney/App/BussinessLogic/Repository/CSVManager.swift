//
//  CSVManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

protocol CSVManager {
    func create() -> String?
    func restorFrom(file name: String)
    func archivesList() -> [String]?
}
