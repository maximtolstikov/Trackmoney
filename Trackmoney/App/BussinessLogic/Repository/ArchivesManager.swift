////
////  ArchivesManager.swift
////  Trackmoney
////
////  Created by Maxim Tolstikov on 10/03/2019.
////  Copyright © 2019 Maxim Tolstikov. All rights reserved.
////
//
//import UIKit
//
protocol ArchivesManager {

    func create(completion: @escaping (String) -> Void)
    func restore(name: String, completion: @escaping (Bool) -> Void)
    func archivesList(completion: @escaping ([String]?) -> Void)
    func deleteList(archives: [String], completion: @escaping () -> Void)
}
