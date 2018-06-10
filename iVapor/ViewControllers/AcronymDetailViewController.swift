//
//  AcronymDetailViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class AcronymDetailViewController: UITableViewController {

    // MARK: - 属性
    var acronym: Acronym? {
        didSet {
            updateAcronymView()
        }
    }
    
    var user: User? {
        didSet {
            updateAcronymView()
        }
    }
    
    var categories: [Category] = [] {
        didSet {
            updateAcronymView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAcronymData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAcronymData()
    }
    
    private func getAcronymData() {
        guard let id = acronym?.id else {
            return
        }
        
        // 创建AcronymRequest来获取数据
        let acronymDetailRequester = AcronymRequest(acronymID: id)
        // 获取Acronym对应的User
        acronymDetailRequester.getUser { [weak self] result in
            // 如果获取成功, 则更新Acronym的user, 否则提示错误信息
            switch result {
            case .success(let user):
                self?.user = user
            case .failure:
                ResultPresenter.showError(message: "获取Acronym的User时出错", on: self)
            }
        }
        
        // 获取Acronym对应的Category数组
        acronymDetailRequester.getCategories { [weak self] result in
            // 如果获取成功, 则更新Acronym的categories, 否则提示错误信息
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure:
                ResultPresenter.showError(message: "获取Acronym的categories时出错", on: self)
            }
        }
    }
    
    private func updateAcronymView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - IBActions
    @IBAction func updateAcronymDetails(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? CreateAcronymViewController else {
            return
        }
        
        user = controller.selectedUser
        acronym = controller.acronym
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 判断segue.identifier(在storyboard中已设置)
        if segue.identifier == "EditAcronymSegue" {
            guard let destination = segue.destination as? CreateAcronymViewController else {
                return
            }
            // 传值, 为CreateAcronymViewController的selectedUser和acronym赋值
            destination.selectedUser = user
            destination.acronym = acronym
        }
    }
}

// MARK: - Table view data source
extension AcronymDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // section == 3 时, cell 有 categories.count 行, 其他组为 1 行
        return section == 3 ? categories.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymDetailCell", for: indexPath)
        
        // 为各组设置  cell.textLabel?.text 的内容
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = acronym?.short
        case 1:
            cell.textLabel?.text = acronym?.long
        case 2:
            cell.textLabel?.text = user?.name
        case 3:
            cell.textLabel?.text = categories[indexPath.row].name
        default:
            break
        }
        
        return cell
    }
    
    /// 设置每组的头部标题
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Acronym"
        case 1:
            return "Meaning"
        case 2:
            return "User"
        case 3:
            return "Categories"
        default:
            return nil
        }
    }
}
