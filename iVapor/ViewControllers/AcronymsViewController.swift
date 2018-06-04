//
//  AcronymsViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class AcronymsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
extension AcronymsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymCell", for: indexPath)
        
        
        return cell
    }
}
