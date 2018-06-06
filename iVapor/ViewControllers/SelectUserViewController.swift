//
//  SelectUserViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class SelectUserViewController: UITableViewController {
    
    // MARK: - 属性
    var users: [User] = []
    var selectedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    /// 加载用于显示到tableView上的数据
    private func loadData() {
        ResultPresenter.show(on: self)
        // 从API中获取所有用户
        let usersRequest = ResourceRequest<User>(resourcePath: "users")
        usersRequest.getAll { [weak self] result in
            switch result {
            // 请求成功, 则保存用户并刷新tableView
            case .success(let users):
                self?.users = users
                DispatchQueue.main.sync { [weak self] in
                    self?.tableView.reloadData()
                }
                ResultPresenter.dismiss(on: self)
            // 请求失败, 则显示错误信息, 点击关闭alertView时, 返回前一个控制器
            case .failure:
                ResultPresenter.dismiss(on: self)
                ResultPresenter.showError(message: "获取用户时出错", on: self) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 在 SelectUserViewController 点击 cell 时, 使用 unwind segue 导航回到 CreateAcronymViewController
        if segue.identifier == "UnwindSelectUserSegue" {
            // 获取触发 segue 的 cell 的 indexPath
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                    return
            }
            // 将 selectedUser 设置为所点击 cell 对应的 user
            selectedUser = users[indexPath.row]
        }
    }
}

// MARK: - Table view data source
extension SelectUserViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectUserCell", for: indexPath)
        cell.textLabel?.text = user.name
        
        // cell 对应的 user 与 selectedUser 作比较, 如果它们是相同的, 则在此cell右边打勾
        if user.id == selectedUser.id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
