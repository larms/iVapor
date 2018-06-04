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
