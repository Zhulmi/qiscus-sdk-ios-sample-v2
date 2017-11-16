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

protocol ContactListViewDelegate {
    func didFinishUpdated()
}

class ContactListViewModel: NSObject {
    var delegate: ContactListViewDelegate?
    var items = [Contact]()
    
    func loadData() {
        var users = QUser.all()
        if users.isEmpty {
            QChatService.roomList(withLimit: 100, page: 1, onSuccess: { (allRooms, totalRoom, currentPage, limit) in
                DispatchQueue.main.async {
                    users = QUser.all()
                }
            }) { (error) in
                print("Failed load list rooms \(error)")
            }
        }
        self.items.removeAll()
        
        guard let contact = ContactList(data: users) else { return }
        self.items.append(contentsOf: contact.contacts)
        
        self.delegate?.didFinishUpdated()
    }
    
    func showDialog(_ email: String, title: String) -> Void {
        let alertController = UIAlertController(title: title,
                                                message: "What would you like to do?",
                                                preferredStyle: .actionSheet)
        
        let detailButton = UIAlertAction(title: "Detail",
                                       style: .default,
                                       handler: { (action) -> Void in
                                        let targetVC = DetailContactVC()
                                        targetVC.email = email
                                        targetVC.hidesBottomBarWhenPushed = true
                                        openViewController(targetVC)
        })
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
        
        alertController.addAction(detailButton)
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
    
    @objc func chatWithStranger(_ sender: Any) {
        let alertController = UIAlertController(title: "Chat With Stranger",
                                                message: "Enter the unique id for your chat target ex: johnny@appleseed.com.",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Unique ID"
        }
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let textField = alertController.textFields![0] as UITextField! else { return }
            if let field = textField.text {
                if !(field.isEmpty) {
                    chatWithUniqueId(field)
                }
            }
        })
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action) -> Void in
                                            print("Cancel button tapped")
        })
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.preferredAction = okButton
        
        presentViewController(alertController)
    }
}

extension ContactListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let email = self.items[indexPath.row].email else { return }
        guard let name = self.items[indexPath.row].name else { return }
        self.showDialog(email, title: name)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactListViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if items.count > 0 {
            tableView.backgroundView?.isHidden = true
            return 1
            
        } else {
            tableView.backgroundView = UIView.backgroundView(UIImage(named: "ic_empty_contact")!,
                                                             title: "Contact is Empty",
                                                             description: "If you chat with stranger, it’ll automaticaly added to here",
                                                             titleButton: "Chat With Stranger",
                                                             iconButton: UIImage(named: "ic_stranger")!,
                                                             target: self,
                                                             action: #selector(chatWithStranger(_:)),
                                                             btnWidth: 244)
            tableView.separatorStyle            = .none
            tableView.backgroundView?.isHidden  = false
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell {
            cell.item = self.items[indexPath.row]
            
            tableView.tableFooterView = UIView()
            
            return cell
        }
        
        return UITableViewCell()
    }
}
