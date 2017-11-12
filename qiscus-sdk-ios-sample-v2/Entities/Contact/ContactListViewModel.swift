//
//  ContactListViewModel.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/9/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import Foundation
import UIKit
import Qiscus

class ContactListViewModel: NSObject {
    var items = [Contact]()
    
    override init() {
        super.init()

        guard let contact = ContactList(data: QUser.all()) else { return }
        self.items.append(contentsOf: contact.contacts)
    }
    
    func showDialog(_ email: String) -> Void {
        let alertController = UIAlertController(title: "Action Sheet",
                                                message: "What would you like to do?",
                                                preferredStyle: .actionSheet)
        
        let chatButton = UIAlertAction(title: "Chat",
                                       style: .default,
                                       handler: { (action) -> Void in
                                        chatWithUser(email)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action) -> Void in
                                            print("Cancel button tapped")
        })
        
        alertController.addAction(chatButton)
        alertController.addAction(cancelButton)
        alertController.preferredAction = chatButton
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if let rootView = app.window?.rootViewController as? UITabBarController {
            if let navigation = rootView.selectedViewController as? UINavigationController {
                navigation.present(alertController, animated: true, completion: nil)
            }
        }
    }

}

extension ContactListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let email = self.items[indexPath.row].email else { return }
        self.showDialog(email)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactListViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell {
            cell.item = self.items[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}
