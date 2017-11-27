//
//  NewChatVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/8/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class NewChatVC: UIViewController, UILoadingView {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel = ChatNewViewModel()
    
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

extension NewChatVC {
    func setupUI() -> Void {
        self.title = "Create New Chat"
        
        self.viewModel.delegate = self
        self.viewModel.loadData()
        
        tableView.backgroundColor       = UIColor.baseBgTableView
        tableView.delegate              = self.viewModel
        tableView.dataSource            = self.viewModel
        tableView.estimatedRowHeight    = 65
        tableView.rowHeight             = UITableViewAutomaticDimension
        tableView.register(CreateGroupCell.nib,
                           forCellReuseIdentifier: CreateGroupCell.identifier)
        tableView.register(CreateStrangerCell.nib,
                           forCellReuseIdentifier: CreateStrangerCell.identifier)
        tableView.register(ContactCell.nib,
                           forCellReuseIdentifier: ContactCell.identifier)
        
        self.setBackTitle()
    }
}

extension NewChatVC: ChatNewViewDelegate {
    func needLoadData() {
        self.showNetworkActivityIndicator()
        self.showWaiting(message: "Plase wait...")
        self.viewModel.loadData()
    }
    
    func didFinishUpdated() {
        self.dismissNetworkActivityIndicator()
        self.dismissLoading()
        self.tableView.reloadData()
    }
}
