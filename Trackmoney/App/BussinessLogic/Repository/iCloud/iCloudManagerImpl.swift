//
//  iCloudManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 03/02/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//


import CloudKit
import Foundation

class ICloudManagerImpl: iCloudManager {
    
    let container = CKContainer(identifier: Configuration().containerIcloud)
    
    func save(record url: URL) -> Error? {
        
        let key = "test" //url.lastPathComponent
        let asset = CKAsset(fileURL: url)
        let record = CKRecord(recordType: Configuration().identifierRecord)
        let privateContainer = container.privateCloudDatabase
        
        record.setObject(asset, forKey: key)
        privateContainer.save(record) { (record, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                assertionFailure()
                return
            }
            print("Save record: \(record?.recordID)")
        }
        
        
        return nil
    }
    
    func query() {
        
    }
    
    func delete() {
        
    }
    
    
    
}
