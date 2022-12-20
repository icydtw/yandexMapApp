//
//  Alert.swift
//  yandexMapApp
//
//  Created by Илья Тимченко on 16.12.2022.
//

import Foundation
import UIKit

extension ViewController {
    func showNotification(completionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Введите адрес", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Окей", style: .default) { action in
            let textFromTextField = alert.textFields?.first
            guard let text = textFromTextField?.text else { return }
            completionHandler(text)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default)
        
        alert.addTextField() { textField in
            textField.placeholder = "Введите текст"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
