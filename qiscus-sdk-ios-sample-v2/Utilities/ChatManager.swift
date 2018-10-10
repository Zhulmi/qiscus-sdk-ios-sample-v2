//
//  ChatManager.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/12/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import Foundation
import Qiscus

public class ChatManager: NSObject {
    static var shared = ChatManager()
    
    override private init() {}
    
    public class func chatWithRoomId(_ roomId: String, contact: Contact? = nil) -> Void {
        let chatView = Qiscus.chatView(withRoomId: roomId)
        chatView.delegate = ChatManager.shared
        chatView.data = contact
        
        chatView.hidesBottomBarWhenPushed = true
        chatView.setBackTitle()
        openViewController(chatView)
    }
    
    /*
     * {email} can be contains of email or uniqueId
     * but in this case we always use value of email
     */
    public class func chatWithUser(_ contact: Contact) {
        guard let email = contact.email else { return }
        let chatView = Qiscus.chatView(withUsers: [email])
        chatView.delegate = ChatManager.shared
        chatView.data = contact
        
        chatView.hidesBottomBarWhenPushed = true
        chatView.setBackTitle()
        openViewController(chatView)
    }
    
    // {uniqueId} can be contains of: email/userId/phone
    public class func chatWithUniqueId(_ uniqueId: String) {
        let chatView = Qiscus.chatView(withUsers: [uniqueId])
        chatView.delegate = ChatManager.shared
        
        chatView.hidesBottomBarWhenPushed = true
        chatView.setBackTitle()
        openViewController(chatView)
    }
    
    public class func createGroupChat(_ users: [String], title: String, avatarURL: String = "") {
        Qiscus.newRoom(withUsers: users, roomName: title, avatarURL: avatarURL, onSuccess: { (room) in
            
            let chatView = Qiscus.chatView(withRoomId: room.id)
            chatView.delegate = ChatManager.shared
            
            chatView.hidesBottomBarWhenPushed = true
            chatView.setBackTitle()
            openViewController(chatView)
            
        }, onError: { (error) in
            print("new room failed: \(error)")
        })
    }
}

extension ChatManager: QiscusChatVCDelegate {
    public func chatVC(enableForwardAction viewController:QiscusChatVC)->Bool{
        return false
    }
    
    public func chatVC(enableInfoAction viewController:QiscusChatVC)->Bool{
        return false
    }
    
    public func chatVC(overrideBackAction viewController:QiscusChatVC)->Bool{
        return true
    }
    
    // MARK: - optional method
    public func chatVC(backAction viewController:QiscusChatVC, room:QRoom?, data:Any?){
        viewController.tabBarController?.selectedIndex = 0
        _ = viewController.navigationController?.popToRootViewController(animated: true)
    }
    
    public func chatVC(titleAction viewController:QiscusChatVC, room:QRoom?, data:Any?){
        guard let r = room else { return }
        
        if r.type == .group {
            let targetVC                        = DetailGroupVC()
            targetVC.id                         = r.id
            targetVC.hidesBottomBarWhenPushed   = true
            viewController.navigationController?.pushViewController(targetVC, animated: true)
            
        } else {
            guard let contact = data as? Contact else { return }
            
            let targetVC                        = DetailContactVC()
            targetVC.enableChatButton           = false
            targetVC.contact                    = contact
            targetVC.hidesBottomBarWhenPushed   = true
            viewController.navigationController?.pushViewController(targetVC, animated: true)
        }
    }
    
    public func chatVC(viewController:QiscusChatVC, willAppear animated:Bool){
        viewController.register(UINib(nibName: "CustomCell", bundle: nil), forChatCellWithReuseIdentifier: "customCell")
        
        //example for post comment
//        if let comment = viewController.chatRoom?.newCustomComment(type: "Custom1", payload: "{ \"bannerUrl\": \"https://www.qiscus.com/images/main_whoops.png\"}", text: "THIS IS CUSTOM MESSAGE"){
//            viewController.chatRoom?.post(comment: comment, onSuccess: {
//                //success
//            }, onError: { (error) in
//                print(error)
//            })
//
//        }
      
    }
    public func chatVC(viewController:QiscusChatVC, willDisappear animated:Bool){
        
    }
    
}

extension ChatManager: QiscusChatVCCellDelegate{
    public func chatVC(viewController: QiscusChatVC, cellForComment comment: QComment, indexPath: IndexPath) -> QChatCell? {
        print("ini custom apa \(comment.type.name())")
        if(comment.typeRaw == "Custom1"){
            let cell = viewController.collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
            cell.setupCell(comment: comment,message: comment.text)
            return cell
        }else{
            //return nil for using default cell
             return nil
        }
       
    }
    
    public func chatVC(viewController: QiscusChatVC, heightForComment comment: QComment) -> QChatCellHeight? {
        if(comment.typeRaw == "Custom1"){
            return QChatCellHeight(height: 295)
        }else{
            //return nil for using default height cell
            return nil
        }
    }
}

