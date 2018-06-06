//
//  CreateAcronymViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class CreateAcronymViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var acronymShortTextField: UITextField!
    @IBOutlet weak var acronymLongTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    // MARK: - 属性
    var selectedUser: User?
    var acronym: Acronym?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acronymShortTextField.becomeFirstResponder()
        populateUsers()
    }
    
    private func populateUsers() {
        // 从API中获取所有用户
        let usersRequest = ResourceRequest<User>(resourcePath: "users")
        usersRequest.getAll { [weak self] result in
            switch result {
            // 请求成功则, 将 userLabel.text 设置为 第一个用户的名字(users[0].name) 并更新 selectedUser
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    self?.userLabel.text = users[0].name
                }
                self?.selectedUser = users[0]
                
            // 请求失败, 则显示错误信息, 点击关闭alertView时, 使用 showError(message:on:dismissAction:) 的 dismissAction闭包 从 CreateAcronymViewController 返回前一个控制器
            case .failure:
                ResultPresenter.showError(message: "获取用户时出错", on: self) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // 确保缩略语
        guard let shortText = acronymShortTextField.text, !shortText.isEmpty else {
            ResultPresenter.showError(message: "必须输入首字母缩略词!", on: self)
            return
        }
        // 确保词义
        guard let longText = acronymLongTextField.text, !longText.isEmpty else {
            ResultPresenter.showError(message: "必须输入词义!", on: self)
            return
        }
        // 确保 selectedUser 有一个有效的ID
        guard let userID = selectedUser?.id else {
            ResultPresenter.showError(message: "必须有一个用户来创建acronym!", on: self)
            return
        }
        
        // 根据提供的数据创建acronym
        let acronym = Acronym(short: shortText, long: longText, userID: userID)
        // 为 acronym 创建 ResourceRequest, 并调用 save(_:completion:) 保存 acronym
        ResourceRequest<Acronym>(resourcePath: "acronyms").save(acronym) { [weak self] result in
            switch result {
            // 保存成功, 返回到上一个控制器: AcronymsViewController
            case .success(_):
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            // 保存失败, 则显示错误信息
            case .failure:
                ResultPresenter.showError(message: "保存acronym是出错", on: self)
            }
        }
        
        
    }
    
    /// unwind segue 在 CreateAcronymViewController 调用 updateSelectedUser(_:)
    @IBAction func updateSelectedUser(_ segue: UIStoryboardSegue) {
        // 确保 segue 来自 SelectUserViewController
        guard let controller = segue.source as? SelectUserViewController else {
            return
        }
        
        // 更新 selectedUser 和 userLabel
        selectedUser = controller.selectedUser
        userLabel.text = selectedUser?.name
    }

    // MARK: - Navigation
    // 在基于storyboard的应用程序中, 通常需要在导航前做一些准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 验证这是点击 userLabel 所在 cell 跳转到 SelectUserViewController 的 segue
        if segue.identifier == "SelectUserSegue" {
            // 确保 segue.destinatio 和 selectedUser 有值
            guard let destination = segue.destination as? SelectUserViewController,
                let user = selectedUser else {
                    return
            }
            // 设置 SelectUserViewController 的 selectedUser
            destination.selectedUser = user
        }
    }
}
