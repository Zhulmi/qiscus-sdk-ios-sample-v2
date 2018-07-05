//
//  DetailGroupVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/18/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class DetailGroupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var id: String?
    fileprivate var viewModel = GroupDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc public func addParticipant() {
        print("add people")
    }
}


extension DetailGroupVC {
    func setupUI() -> Void {
        self.title = "Group Info"
        
        // MARK: - Register table & cell
        guard let roomId = self.id else { return }
        
        viewModel.id                    = roomId
        tableView.backgroundColor       = UIColor.baseBgTableView
        tableView.delegate              = self.viewModel
        tableView.dataSource            = self.viewModel
        tableView.register(GroupPictureCell.nib,
                           forCellReuseIdentifier: GroupPictureCell.identifier)
        tableView.register(ParticipantCell.nib,
                           forCellReuseIdentifier: ParticipantCell.identifier)
        
        // MARK: - Add right button add contact
        let btnAddContact: UIButton     = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let imageAddContact: UIImage    = UIImage(named: "ic_person_add")!.withRenderingMode(.alwaysTemplate)
        btnAddContact.tintColor         = UIColor.white
        
        btnAddContact.setImage(imageAddContact, for: .normal)
        btnAddContact.addTarget(self, action: #selector(DetailGroupVC.addParticipant), for: .touchUpInside)
        
        let saveButton = UIBarButtonItem(customView: btnAddContact)
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.setBackIcon()
    }
}
