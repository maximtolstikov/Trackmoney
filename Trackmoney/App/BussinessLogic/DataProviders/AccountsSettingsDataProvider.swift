import CoreData
import UIKit

class AccountsSettingsDataProvider: DataProviderProtocol {
    
    var dbManager: DBManagerProtocol?
    weak var controller: AccountsSettingsController?
    
    func loadData() {
        
        let all = NSPredicate(value: true)
        let result = dbManager?.get(all)
        
        guard let objects = result else {
            if controller != nil {
                // swiftlint:disable next force_unwrapping
                ShortAlert().show(controller: controller!,
                                  title: result?.description,
                                  body: nil,
                                  style: .alert)
            }
            assertionFailure()
            return
        }
        
        controller?.accounts = objects as? [Account]
    }
    
    func save(message: [MessageKeyType: Any]) {
        
//        let result = dbManager?.create(message)
//        
//        if result?.0 != nil, controller != nil {
//            
//            ShortAlert().show(
//                controller: controller!,
//                title: NSLocalizedString("accountCreate", comment: ""),
//                body: nil, style: .alert)
//            
//            loadData()
//            
//        } else {
//            if result?.1 != nil, controller != nil {
//                NeedCancelAlert().show(
//                    controller: controller!,
//                    title: result?.1?.description,
//                    body: nil)
//            }
//        }
        
    }
    
    func delete(with id: String, completion: @escaping (Bool) -> Void) {
        
        guard let controller = controller else { return }
        
        AcceptAlert().show(controller: controller,
                           title: NSLocalizedString("acceptDeleteTitle",
                                                    comment: ""),
                           body: nil) { [unowned self] (flag) in
                            if flag {
                                let error = self.dbManager?.delete(id)
                                
                                if error == nil {
  
                                    ShortAlert().show(
                                        controller: controller,
                                        title: NSLocalizedString("accountDelete", comment: ""),
                                        body: nil,
                                        style: .alert)
                                    
                                    completion(true)
                                    
                                } else {
                                    if error != nil {
                                        NeedCancelAlert().show(
                                            controller: controller,
                                            title: error!.description,
                                            body: nil)
                                    }
                                }
                            }
        }
    }
    
}
