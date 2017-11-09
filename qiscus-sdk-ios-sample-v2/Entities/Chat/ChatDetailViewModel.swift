//
//  ChatDetailViewModel.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/8/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import Foundation
import UIKit

enum ChatDetailViewModelItemType {
    case nameAndPicture
    case participants
    case leave
}

protocol ChatDetailViewModelItem {
    var type: ChatDetailViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class ChatDetailViewModel: NSObject {
    var items = [ChatDetailViewModelItem]()
    
    override init() {
        super.init()
        
        guard let data = parseJsonFile("ChatDummy"), let chat = Chat(data: data) else { return }
        
        // name and picture section
        let nameAndPictureItem = ChatDetailViewModelNamePictureItem(name: "Rohmad Sasmito", avatarURL: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg")
        items.append(nameAndPictureItem)
        
        // participants section
        let participants = chat.participants
        if !participants.isEmpty {
            let participantsItem = ChatDetailViewModelParticipantsItem(participants: participants)
            items.append(participantsItem)
        }
        
        // leave section
        let leaveItem = ChatDetailViewModelLeaveItem(target: UIViewController(), #selector(leaveAction(_:)))
        items.append(leaveItem)
    }
    
    @objc func leaveAction(_ sender: Any) {
        print("leave action...")
    }
}

extension ChatDetailViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .nameAndPicture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
        case .participants:
            if let item = item as? ChatDetailViewModelParticipantsItem, let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantCell.identifier, for: indexPath) as? ParticipantCell {
                let participant = item.participants[indexPath.row]
                cell.item = participant
                return cell
            }
        case .leave:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LeaveCell.identifier, for: indexPath) as? LeaveCell {
                cell.item = item
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}



// MARK: - Handle response of each cell
class ChatDetailViewModelNamePictureItem: ChatDetailViewModelItem {
    var type: ChatDetailViewModelItemType {
        return .nameAndPicture
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name: String
    var avatarURL: String
    
    init(name: String, avatarURL: String) {
        self.name = name
        self.avatarURL = avatarURL
    }
}

class ChatDetailViewModelParticipantsItem: ChatDetailViewModelItem {
    var type: ChatDetailViewModelItemType {
        return .participants
    }
    
    var sectionTitle: String {
        return "Participants"
    }
    
    var rowCount: Int {
        return participants.count
    }
    
    var participants: [Participant]
    
    init(participants: [Participant]) {
        self.participants = participants
    }
}

class ChatDetailViewModelLeaveItem: ChatDetailViewModelItem {
    var type: ChatDetailViewModelItemType {
        return .leave
    }
    
    var sectionTitle: String {
        return " "
    }
    
    var rowCount: Int {
        return 1
    }
    
    var target: UIViewController
    var action: Selector
    
    init(target: UIViewController, _ action: Selector) {
        self.target = target
        self.action = action
    }
    
}
