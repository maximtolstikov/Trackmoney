//
//  CSVManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

protocol CSVManager {
    func create(completionHandler: @escaping (String?) -> Void)
    func restorFrom(file name: String, completionHandler: @escaping (Bool) -> Void)
    func archivesList(completionHandler: @escaping ([String]?) -> Void)
    func deleteItems(_ list: [String], completion: @escaping () -> Void)
}
