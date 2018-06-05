//
//  UsersViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {

    // MARK: - 属性
    var users: [User] = []
    private let usersRequest = ResourceRequest<User>(resourcePath: "users")
    
    /// 刷新控件
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 1, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    @objc private func getData() {
        ResultPresenter.show(on: self)
        
        // 调用 getAll(completion:) 获取所有的Acronym, 将在 completion(_:)闭包 中返回结果
        usersRequest.getAll { [weak self] result in
            // 当请求完成时, 刷新控件结束刷新
            let deadline = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
                self?.refresher.endRefreshing()
            }
            
            switch result {
            // 获取成功, 则从结果中更新Acronym数组并刷新tableView
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    self?.users = users
                    self?.tableView.reloadData()
                    ResultPresenter.dismiss(on: self)
                    ResultPresenter.showSuccess(message: "已获取最新数据", on: self)
                }
            // 获取失败, 则使用ErrorPresenter来显示适当错误信息的弹框
            case .failure:
                ResultPresenter.dismiss(on: self)
                ResultPresenter.showError(message: "获取acronyms时出错", on: self)
            }
        }
    }
}

// MARK: - Table view data source
extension UsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.username
        
        return cell
    }
}
