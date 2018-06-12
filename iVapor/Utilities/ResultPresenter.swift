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
            alertController.addBlurEffectCover()
            vc?.present(alertController, animated: true)
        }
    }
    
    static func showSuccess(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
            alertController.addBlurEffectCover()
            vc?.present(alertController, animated: true)
            
            // 一会儿自动 dismiss
            let deadline = DispatchTime.now() + .milliseconds(1200)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                vc?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    static func show(title: String = "获取数据中...", message: String? = "", on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var vc = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addBlurEffectCover()
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
            alertController.addBlurEffectCover()
            vc?.present(alertController, animated: true)
        }
    }
    
    static func dismiss(on viewController: UIViewController?) {
        DispatchQueue.main.async {
            viewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

let kScreenH = UIScreen.main.bounds.size.height
let kScreenScale = UIScreen.main.scale
/// AlertView 只有 title 时的高度
private let onlyTitleH: CGFloat = 30
/// AlertView 包含 title 和 message
private let titleAddMessageH: CGFloat = 40
/// AlertView 包含 actions, title 和 message
private let multieH: CGFloat = 62
private let actionBtnH: CGFloat = 22

extension UIAlertController {
    /// alertView 的高度约束值, 如果 alertView 的内容显示不全时调整这个数值
    private static var alertViewHeight: CGFloat = multieH * kScreenScale
    
    
    /// 为 UIAlertController 添加 BlurEffect 遮盖效果, 设置在其他子控件之后
    func addBlurEffectCover(style: UIBlurEffectStyle = .light) {
        // 设置圆角
        let subview = view.subviews.first
        let contentView = subview?.subviews.first
//        contentView?.backgroundColor = UIColor.red    // 设置背景颜色, 自带的BlurEffect还在的
        contentView?.layer.cornerRadius = 30
        contentView?.layer.masksToBounds = true
        // actionButton 字体的颜色
//        view.tintColor = .red
        
        // 设置title的颜色
        if let title = title {
            let titleAttributed = NSMutableAttributedString(string: title, attributes: [.font: UIFont.boldSystemFont(ofSize: 17), .foregroundColor : #colorLiteral(red: 0, green: 0.6941176471, blue: 1, alpha: 1)])
            setValue(titleAttributed, forKey: "attributedTitle")
        }
        // 设置message的颜色
        if let message = message {
            let messageAttributed = NSMutableAttributedString(string: message, attributes:  [.font: UIFont.systemFont(ofSize: 13), .foregroundColor : #colorLiteral(red: 0, green: 0.6941176471, blue: 1, alpha: 1)])
            setValue(messageAttributed, forKey: "attributedMessage")
        }

        var y: CGFloat
        var num: CGFloat
        let count = actions.count
        if count == 0 && message == "" {    // 只有 title
            UIAlertController.alertViewHeight = onlyTitleH * kScreenScale
            y = -kScreenH / 2 + onlyTitleH
        } else if count == 0 && message != ""  {    // 只有 title 和 message
            UIAlertController.alertViewHeight = titleAddMessageH * kScreenScale
            y = -kScreenH / 2 + titleAddMessageH
        } else if actions.count > 0 && message != "" {    // 有 actions, title 和 message
            if actions.count == 2 { // 2个 actionButton 时, 会左右并排显示, 此时相当于1个 actionButton 的高度
                num = titleAddMessageH + actionBtnH
                UIAlertController.alertViewHeight = num * kScreenScale
                y = -kScreenH / 2 + num
            } else {
                num = titleAddMessageH + actionBtnH * CGFloat(count)
                UIAlertController.alertViewHeight = num * kScreenScale
                y = -kScreenH / 2 + num
            }
        } else {    // 包含 actions 和 title, 没有 message
            if actions.count == 2 {
                num = onlyTitleH + actionBtnH
                UIAlertController.alertViewHeight = num * kScreenScale
                y = -kScreenH / 2 + num
            } else {
                num = onlyTitleH + actionBtnH * CGFloat(count)
                UIAlertController.alertViewHeight = num * kScreenScale
                y = -kScreenH / 2 + num
            }
        }
        
        // 修改 UIAlertController.view 的高度约束
        let heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIAlertController.alertViewHeight)
        view.addConstraint(heightConstraint)
        
        // 修改 UIAlertController.view 的宽度约束(不可设置太小, 会打印一堆约束警告信息)为屏幕的宽度, 可以使 blurVisualEffectView 的宽度占据屏幕宽度
        let width: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)
        view.addConstraint(width)
        
        let blurEffect = UIBlurEffect(style: style)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame.size = UIScreen.main.bounds.size
        blurVisualEffectView.frame.origin.y = y
        
        view.insertSubview(blurVisualEffectView, at: 0)
    }
}

private extension UIView {
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
}

// blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]    // 支持横竖屏, 不一定生效
// 设置alertView的颜色
//let subview = alertController.view.subviews.first?.subviews.first?.subviews.first
//subview?.backgroundColor = UIColor(red: (145/255.0), green: (200/255.0), blue: (0/255.0), alpha: 1.0)
// 设置alertView的blurEffect效果
//if let visualEffectView = alertController.view.searchVisualEffectsSubview() {
//    visualEffectView.effect = UIBlurEffect(style: .light)
//}
