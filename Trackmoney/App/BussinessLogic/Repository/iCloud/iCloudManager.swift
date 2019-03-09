//
//  iCloudManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 03/02/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import Foundation

/**
 Работает с приватным контейнером CloudKit
 */

protocol iCloudManager {
    
    func save(record url: URL) -> Error?
    func query()
    func delete()
}
