//
//  ErrorPresenter.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class ErrorPresenter {
    static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: dismissAction))
            vc?.present(alertController, animated: true)
        }
    }
}
