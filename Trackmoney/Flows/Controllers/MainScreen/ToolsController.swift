//Для описания контроллера Инструменты

import UIKit

class ToolsController: UIViewController {
    
    var dataLoader: DataProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingsButton()
    }
    
    
    // Устанавливает кнопку настроеек сверху справа
    private func setSettingsButton() {
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(named: "Settings"),
            style: .done,
            target: self,
            action: #selector(tapSettingsButton))
        self.navigationItem.rightBarButtonItem = settingsButton
        
    }
    
    
    // по нажатию на кнопку "настройки" переход на котроллер настроек
    @objc func tapSettingsButton() {
        
        let settingsController = UINavigationController(
            rootViewController: SettigsControllerBilder().viewController())
        present(settingsController, animated: true, completion: nil)
        
    }

}
