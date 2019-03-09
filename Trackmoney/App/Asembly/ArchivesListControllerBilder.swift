//
//  ArchivesListControllerBilder.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import UIKit

class ArchivesListControllerBuilder {
    
    func viewController() -> UIViewController {
        
        let controller = ArchivesListController()
        controller.title = NSLocalizedString(
            "archiveListControllerTitle", comment: "")
        let csvManager = CSVManagerImpl()
        let alert = NeedCancelAlert()
        controller.csvManager = csvManager
        controller.alert = alert
        
        return controller
    }
}
