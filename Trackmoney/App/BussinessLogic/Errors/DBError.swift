import UIKit


enum DBError: Error, Equatable {
    
    // swiftlint:disable next identifier_name
    case accountHaveTransaction([String])      // = "accountHaveTransaction"
    case contextDoNotBeSaved         // = "Контекст не может быть сохранен!"
    case messageHaventRequireValue   // = "Сообщение не содержит нужного значения!"
    case noName                      //  = "No name error..."
    case objectCanntGetFromBase      // = "Объект не может быть получен из Базы!"
    case objectIsExistAlready        // = "Такой объект уже существует!"
    case objectIsNotExist            // = "Такого объекта не существует!"
}
    
extension DBError: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .accountHaveTransaction(let dates):
            return NSLocalizedString("accountHaveTransaction", comment: "") + " " + dates.description
        case .contextDoNotBeSaved:
            return NSLocalizedString("contextDoNotBeSaved", comment: "")
        case .messageHaventRequireValue:
            return NSLocalizedString("messageHaventRequireValue", comment: "")
        case .noName:
            return NSLocalizedString("noName", comment: "")
        case .objectCanntGetFromBase:
            return NSLocalizedString("objectCanntGetFromBase", comment: "")
        case .objectIsExistAlready:
            return NSLocalizedString("objectIsExistAlready", comment: "")
        case .objectIsNotExist:
            return NSLocalizedString("objectIsNotExist", comment: "")
        }
    }
    
}
