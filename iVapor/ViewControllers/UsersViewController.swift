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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh(nil)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        DispatchQueue.main.async {
            sender?.endRefreshing()
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
