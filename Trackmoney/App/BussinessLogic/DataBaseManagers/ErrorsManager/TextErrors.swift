// Для перечисления ошибок


enum TextErrors: String {
    
    case accountIsNotExist = "Такого счета не существует!"
    case accountIsExistAlready = "Такой счет уже существует!"
    case categoryIsNotExist = "Такой категории не существует!"
    case categoryIsExistAlready = "Такая категория уже существует!"
    case transactionIsNotExist = "Такой транзакции не существует!"
    case transactionIsExist = "Такая транзакция уже существует!"    
    case contextDoNotBeSaved = "Контекст не может быть сохранен!"
    case noName = "No name error..."
   
}
