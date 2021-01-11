//
//  UIViewController+Alert.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 31/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, message: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            handler?()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func show(_ error: Error) {
        self.showAlert(withTitle: "Something went wrong", message: error.localizedDescription)
    }
}
