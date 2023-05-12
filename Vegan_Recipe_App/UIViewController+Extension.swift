//
//  UIViewController+Extension.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2023/01/17.
//

import UIKit

extension UIViewController {
    // Universal method to show error messages
    func showFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}
