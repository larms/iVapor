//
//  ResultPresenter.swift
//  iVapor
//
//  Created by larms on 5/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class ResultPresenter {
    static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "出错", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "关闭", style: .default, handler: dismissAction))
            vc?.present(alertController, animated: true)
        }
    }
    
    static func showSuccess(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
            vc?.present(alertController, animated: true)
            
            // 一会儿自动 dismiss
            let deadline = DispatchTime.now() + .milliseconds(1200)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                vc?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    static func show(message: String? = "", on viewController: UIViewController? = nil, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "获取数据中...", message: message, preferredStyle: .alert)
            vc?.present(alertController, animated: true)
        }
    }
    
    static func dismiss(on viewController: UIViewController?) {
        viewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
