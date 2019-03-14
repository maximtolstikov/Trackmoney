//
//  iCloudManager.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 03/02/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//


import CloudKit
import UIKit

class ICloudManager: ArchivesManager {
    
    // MARK: - Lazy properties
    
    lazy var creatorString = CreaterStringsFromEntity()
    lazy var creatorEntities = CreaterEntitysFromString()
    
    // MARK: - Private properties
    
    private let congiguration = Configuration()
    private let container: CKContainer
    private let dataBase: CKDatabase
    private var backgroundTaskID: UIBackgroundTaskIdentifier?
    
    // MARK: - Init
    
    init() {
        self.container = CKContainer(identifier: congiguration.containerIcloud)
        self.dataBase = container.privateCloudDatabase
    }
    
    // MARK: - Public methods
    
    /// Создает архив даже в бэкграунде в iCloud
    func create(completion: @escaping (String) -> Void) {

        //swiftlint:disable closure_end_indentation
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared
                .beginBackgroundTask(withName: Configuration().createArchiveBackgroundName) {
                    guard let id = self.backgroundTaskID else { return }
                    UIApplication.shared.endBackgroundTask(id)
                    self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            // upload record in iCloud
            DispatchQueue.main.async {
                self.uploadArchive(completion: { (name) in
                    completion(name)
                })
            }
            
            guard let id = self.backgroundTaskID else { return }
            UIApplication.shared.endBackgroundTask(id)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    
    /// Восстанавливает базу из архива
    ///
    /// - Parameters:
    ///   - name: имя архива
    ///   - completion: флаг успеха
    func restore(name: String, completion: @escaping (Bool) -> Void) {
        
        //swiftlint:disable closure_end_indentation
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared
                .beginBackgroundTask(withName: Configuration().createArchiveBackgroundName) {
                    guard let id = self.backgroundTaskID else { return }
                    UIApplication.shared.endBackgroundTask(id)
                    self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            // upload record in iCloud
            
            self.fetchArchiveBy(name: name) { (line) in
                guard let line = line else {
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    let result = self.creatorEntities.restore(from: line)
                    completion(result)
                }
            }
            
            guard let id = self.backgroundTaskID else { return }
            UIApplication.shared.endBackgroundTask(id)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    
    /// Возвращает список имен архивов
    ///
    /// - Parameter completion: список
    func archivesList(completion: @escaping ([String]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: congiguration.typeRecord, predicate: predicate)
        
        dataBase.perform(query, inZoneWith: nil) { results, error in
            var list = [String]()
            defer {
                completion(list)
            }
            
            guard error == nil,
                let results = results else {
                    //swiftlint:disable next force_unwrapping
                    print(error!.localizedDescription)
                    return
            }
            
            results.forEach { list.append($0.recordID.recordName) }
        }
    }

    
    /// Удаляет архивы из списка
    ///
    /// - Parameters:
    ///   - archives: список имен
    ///   - completion: обратный вызов
    func deleteList(archives: [String], completion: @escaping () -> Void) {
        
        archives.forEach { (name) in
            delete(archive: name, completion: {
                completion()
            })
        }
    }
    
    
    // MARK: - Private methods
    
    /// Возвращает строку архива из iCloud
    ///
    /// - Parameters:
    ///   - name: Имя файла архива
    ///   - completion: содержимое архива
    private func fetchArchiveBy(name: String, completion: @escaping (String?) -> Void) {
        
        let recordId = CKRecord.ID(recordName: name)
        dataBase.fetch(withRecordID: recordId) { (record, error) in
            
            guard error == nil, let record = record else {
                //swiftlint:disable next force_unwrapping
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            //swiftlint:disable next force_cast
            let line = record["content"] as! String
            completion(line)
        }
    }
    
    
    /// Сохраняет запись в iCloud
    private func uploadArchive(completion: @escaping (String) -> Void) {
        creatorString.string { (line) in
            
            guard let line = line else { return }
            let record = self.createRecordWith(line: line)
            
            self.dataBase.save(record) { (record, error) in
                guard error == nil, let record = record else {
                    print(String(describing: error?.localizedDescription))
                    return
                }
                
                completion(record.recordID.recordName)
                
                UserNotificationManager.shared
                    .addNotification(
                        title: NSLocalizedString("successfulCreateArchiveTitile", comment: ""),
                        body: record.recordID.recordName)
                print("Save record: \(String(describing: record.recordID.recordName))")
            }
        }
    }
    
    
    /// Создает запись c архивом
    ///
    /// - Parameter line: строка архива
    /// - Returns: Запись
    private func createRecordWith(line: String) -> CKRecord {
            let name = currentName()
            let recordId = CKRecord.ID(recordName: name)
            let record = CKRecord(recordType: congiguration.typeRecord, recordID: recordId)
            record["content"] = line
            return record
    }
    
    
    /// Возвращает имя с текущим временем
    private func currentName() -> String {
        let date = DateSetter().date().replacingOccurrences(of: ",", with: ".")
        return "\(date)" + ".csv"
    }
    
    /// Удаляет запись из iCloud
    ///
    /// - Parameters:
    ///   - archive: Имя архива
    ///   - completion: обратный вызов
    private func delete(archive: String, completion: @escaping () -> Void) {
        
        let recordId = CKRecord.ID(recordName: archive)
        dataBase.delete(withRecordID: recordId) { (_, error) in
            if error != nil {
                //swiftlint:disable next force_unwrapping
                print(error!.localizedDescription)
            }
            completion()
        }
    }
    
}
