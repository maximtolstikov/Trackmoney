// Для определения базового класса DataBaseManager

import CoreData
import UIKit

class DBManager {
    
    //swiftlint:disable force_cast
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let mManager = MessageManager()
    
}
