//
//  CreateCategoryViewController.swift
//  iVapor
//
//  Created by larms on 3/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import UIKit

class CreateCategoryViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
    }

    // MARK: - IBActions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            ErrorPresenter.showError(message: "必须输入name!", on: self)
            return
        }
        
        let category = Category(name: name)
        ResourceRequest<Category>(resourcePath: "categories").save(category) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure:
                ErrorPresenter.showError(message: "保存Category存在问题", on: self)
            }
        }
    }
}
