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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        
        return cell
    }
}
