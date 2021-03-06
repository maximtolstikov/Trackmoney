//
//  Configure.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 03/02/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

/**
 Содержит основные настройки приложения
 */

struct Configuration {
    
    // Идентификатор контейнера iCloud
    let containerIcloud = "iCloud.X37P9Q6XJNme.trackmoney.Trackmoney"
    // Тип записи в iCloud
    let typeRecord = "ArchiveType"
    // Ключ для хранения файла в записи
    let assetKey = "Archive"
    // Имя фоновой задачи создания архива
    let createArchiveBackgroundName = "createArchiveBackgroundName"
}
