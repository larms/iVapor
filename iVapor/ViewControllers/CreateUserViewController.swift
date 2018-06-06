//
//  CreateUserViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class CreateUserViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
    }

    // MARK: - IBActions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // 确保 nameTextField 非空
        guard let name = nameTextField.text, !name.isEmpty else {
            ResultPresenter.showError(message: "必须输入name!", on: self)
            return
        }
        
        // 确保 usernameTextField 非空
        guard let username = usernameTextField.text, !username.isEmpty else {
            ResultPresenter.showError(message: "必须输入username!", on: self)
            return
        }
        
        let user = User(name: name, username: username)
        // 为 user 创建 ResourceRequest, 并调用 save(_:completion:) 保存 user
        ResourceRequest<User>(resourcePath: "users").save(user) { [weak self] result in
            switch result {
            // 保存成功, 返回到上一个控制器: UsersViewController
            case .success(_):
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            // 保存失败, 则显示错误信息
            case .failure:
                ResultPresenter.showError(message: "保存用户存在问题", on: self)
            }
        }
    }
}
