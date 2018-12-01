// Для перечисления ошибок


enum TextErrors: String {
    
    case objectIsNotExist = "Такого объекта не существует!"
    case objectIsExistAlready = "Такой объект уже существует!"   
    case contextDoNotBeSaved = "Контекст не может быть сохранен!"
    case messageHaventRequireValue = "Сообщение не содержит нужного значения!"
    case objectCanntGetFromBase = "Объект не может быть получен из Базы!"
    case noName = "No name error..."
   
}
