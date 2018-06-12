//
//  AcronymsViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class AcronymsViewController: UITableViewController {

    // MARK: - 属性
    /// Acronym数组, 数组中存放tableView显示的数据
    var acronyms: [Acronym] = []
    /// 创建ResourceRequest, https://usingvapor3.vapor.cloud/api/acronyms
    private let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronyms")
    
    /// 刷新控件
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 1, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        // 设置tableFooterView, 这样tableView就不会显示空白的cell了
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getData()
    }
    
    @objc private func getData() {
        ResultPresenter.show(on: self)
        
        // 调用 getAll(completion:) 获取所有的Acronym, 将在 completion(_:)闭包 中返回结果
        acronymsRequest.getAll { [weak self] result in
            // 当请求完成时, 刷新控件结束刷新
            let deadline = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
                self?.refresher.endRefreshing()
            }
            
            switch result {
            // 获取成功, 则从结果中更新Acronym数组并刷新tableView
            case .success(let acronyms):
                DispatchQueue.main.async { [weak self] in
                    self?.acronyms = acronyms
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
    
    // MARK: - Navigation
    // 在基于storyboard的应用程序中, 通常需要在导航前做一些准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 验证这是点击 cell 跳转到 AcronymDetailViewController 的 segue
        if segue.identifier == "AcronymsToAcronymDetail" {
            // 确保 segue.destinatio 和 selectedUser 有值
            guard let destination = segue.destination as? AcronymDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                    return
            }
            // 设置 AcronymDetailViewController 的 acronym
            destination.acronym = acronyms[indexPath.row]
        }
    }
}

// MARK: - Table view data source
extension AcronymsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acronyms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acronym = acronyms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymCell", for: indexPath)
        cell.textLabel?.text = acronym.short
        cell.detailTextLabel?.text = acronym.long
        
        return cell
    }
    
    /// cell 左滑删除 Acronym
    /// 如果此 Acronym 关联了 categorys, 它不会因为 App 在 API 中删除而删除, 下拉刷新 tableView 将会再次出现
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 创建 AcronymRequest 并调用 delete() 删除API中 acronymID 对应的 Acronym
        if let id = acronyms[indexPath.row].id {
            let acronymDetailRequester = AcronymRequest(acronymID: id)
            acronymDetailRequester.delete()
        }
        
        // 从 acronyms 中删除该 Acronym
        acronyms.remove(at: indexPath.row)
        // 用 .automatic 动画效果移除这个cell
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
