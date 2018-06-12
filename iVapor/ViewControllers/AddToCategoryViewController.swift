//
//  AddToCategoryViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class AddToCategoryViewController: UITableViewController {
    
    // MARK: - 属性
    var categories: [Category] = []
    var selectedCategories: [Category]!
    var acronym: Acronym!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResultPresenter.show(on: self)
        loadData()
    }
    
    private func loadData() {
        // 创建 ResourceRequest 并获取所有 Category
        let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
        categoriesRequest.getAll { [weak self] result in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async { [weak self] in
                    self?.categories = categories
                    self?.tableView.reloadData()
                }
                ResultPresenter.dismiss(on: self)
            case .failure:
                ResultPresenter.dismiss(on: self)
                ResultPresenter.showError(message: "获取categories时出错!", on: self)
            }
        }
    }
}

// MARK: - Table view data source
extension AddToCategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        
        let isSelected = selectedCategories.contains { element in
            element.name == category.name
        }
        if isSelected {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension AddToCategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 获取选中的Category
        let category = categories[indexPath.row]
        // 如果已添加过此Category, 则弹出提示信息
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.accessoryType == .checkmark {
            ResultPresenter.show(title: "此Category已添加过", on: self)
            self.tableView.reloadData()
            return
        }
        
        // 确保 acronymID 有效
        guard let acronymID = acronym.id else {
            ResultPresenter.showError(message: "acronymID不存在, 无法添加到Category", on: self)
            return
        }
        // 创建 AcronymReques, 并将 Acronym 添加到 Category
        let acronymRequest = AcronymRequest(acronymID: acronymID)
        acronymRequest.add(category: category) { [weak self] result in
            switch result {
            case .success:  // 成功则返回上一个界面
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure:
                ResultPresenter.showError(message: "将Acronym添加到Category中出错。", on: self)
            }
        }
    }
}
