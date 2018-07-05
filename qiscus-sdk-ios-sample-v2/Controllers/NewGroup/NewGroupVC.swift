//
//  NewGroupVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/8/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit
import Qiscus

class NewGroupVC: UIViewController, UILoadingView {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate var viewModel: GroupNewViewModel?
    var isFromGroupInfo = false
    var roomId = ""
    var selectedContacts = [Contact]() {
        didSet {
            let isEnable: Bool = isFromGroupInfo ? (selectedContacts.count > 0) : (selectedContacts.count > 1)
            self.isEnableButton(isEnable)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = GroupNewViewModel(delegate: self)
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewGroupVC {
    func setupUI() -> Void {
        self.title = "Select Participants"
        
        // MARK: - Register search controller
        searchController.searchResultsUpdater = self.viewModel
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        // MARK: - Register table & cell
        tableView.delegate = self.viewModel
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 76
        tableView.dataSource = self.viewModel
        tableView.register(ContactCell.nib,
                           forCellReuseIdentifier: ContactCell.identifier)
        
        // add button in navigation right
        let rightButton = UIBarButtonItem(title: "Next",
                                          style: .done,
                                          target: self,
                                          action: #selector(next(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.isEnableButton(false)
        self.setBackTitle()
    }
 
    func isEnableButton(_ enable: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    @objc func next(_ sender: Any) {
        if isFromGroupInfo {
            let participantUserIds = self.selectedContacts.map({ (contact) -> String in
                return contact.email!
            })
            
            Qiscus.addParticipant(onRoomId: roomId, userIds: participantUserIds, onSuccess: { (qRoom) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }, onError: { (error, code) in
                
            })
        } else {
            let view = NewGroupInfoVC()
            view.selectedContacts = self.selectedContacts
            view.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}

extension NewGroupVC: GroupNewViewDelegate {
    func showLoading() {
        showWaiting(message: "Loading")
    }
    
    func didFailedLoadItem() {
        dismissLoading()
    }
    
    func itemsDidChanged(contacts: [Contact]) {
        self.selectedContacts.removeAll()
        self.selectedContacts.append(contentsOf: contacts)
        self.tableView.reloadData()
        dismissLoading()
    }
    
    func filterSearchDidChanged() {
        self.tableView.reloadData()
    }
}
