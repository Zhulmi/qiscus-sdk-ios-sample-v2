//
//  ChatListCell.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Qiscus on 27/06/18.
//  Copyright © 2018 Qiscus Technology. All rights reserved.
//

import UIKit
import Qiscus

class ChatListCell: QRoomListCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var viewUnreadCount: UIView!
    @IBOutlet weak var lbUnreadCount: UILabel!
    @IBOutlet weak var notifImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func onRoomChange(room: QRoom) {
        if room.unreadCount > 0 {
            if room.unreadCount > 99 {
                lbUnreadCount.text = "99+"
            } else {
                lbUnreadCount.text = "\(room.unreadCount)"
            }
        }
        
        viewUnreadCount.isHidden = lbUnreadCount.text == "0" ? true : false
    }
    
    override func onUserTyping(user: QUser, typing: Bool) {
        if typing {
            lastMessageLabel.text   = "\(user.fullname) is typing..."
        }else {
            setMessageTime()
        }
    }
    
    override func setupUI() {
        self.setAvatar()
        self.setName()
        self.setMessageTime()
        self.setUnreadCount()
    }
    
    // MARK: - Custom methods from ChatCell class
    private func setName() -> Void {
        guard let r = room else { return }
        chatNameLabel.text = r.name
    }
    
    private func setMessageTime() -> Void {
        guard let r = room else { return }
        
        if let message = r.lastComment {
            let messageText: String     = (message.type == .text) ? message.text : "Sending attachment"
            let timestampText: String   = message.date.timestampFormat(of: message.time)
            lastMessageLabel.text       = messageText
            timestampLabel.text         = timestampText
            
        } else {
            lastMessageLabel.text   = ""
            timestampLabel.text     = "-"
        }
    }
    
    private func setUnreadCount() -> Void {
        guard let r = room else { return }
        lbUnreadCount.text = "\(r.unreadCount)"
        viewUnreadCount.isHidden = lbUnreadCount.text == "0" ? true : false
        
        viewUnreadCount.layer.cornerRadius = viewUnreadCount.frame.height/2
    }
    
    private func setAvatar() -> Void {
        guard let r = room else { return }
        let imageDefault = (r.type == .group) ? UIImage(named: "ic_default_group") : UIImage(named: "ic_default_avatar")
       
        avatarImageView.loadAsync(r.avatarURL, placeholderImage: imageDefault, header: Helper.headers)
         avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
}
