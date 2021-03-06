//
//  SettingVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/12/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingVC {
    func setupUI() -> Void {
        self.title = "Setting"
        
        tableView.backgroundColor       = UIColor.baseBgTableView
        tableView.delegate              = self.viewModel
        tableView.dataSource            = self.viewModel
        tableView.estimatedRowHeight    = 100
        tableView.rowHeight             = UITableViewAutomaticDimension
        tableView.register(ContactPictureCell.nib,
                           forCellReuseIdentifier: ContactPictureCell.identifier)
        tableView.register(ActionCell.nib,
                           forCellReuseIdentifier: ActionCell.identifier)
    }
}
