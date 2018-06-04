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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - IBActions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateSelectedUser(_ segue: UIStoryboardSegue) {
    }

    // MARK: - Navigation
    // 在基于storyboard的应用程序中, 通常需要在导航前做一些准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
