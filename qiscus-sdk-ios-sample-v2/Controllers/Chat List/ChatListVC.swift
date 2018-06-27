//
//  ChatListVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Qiscus on 27/06/18.
//  Copyright © 2018 Qiscus Technology. All rights reserved.
//

import UIKit
import Qiscus

class ChatListVC: UIViewController {

    @IBOutlet weak var tableview: QRoomList!
    
    var rooms = [QRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat List"
        
        self.tableview.listDelegate = self
        self.tableview.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "ChatListCell")
        self.rooms = QRoom.all()
        
        // add button in navigation right
        let rightButton = UIBarButtonItem(image: UIImage(named: "ic_new_chat"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(newChat(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func newChat(_ sender: Any) {
        let view = NewChatVC()
        
        view.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.rooms.count > 0 {
            //self.roomListView.rooms = self.rooms
            self.tableview.reload()
            Qiscus.subscribeAllRoomNotification()
        }else{
            self.loadRoomList()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchText(){
        //self.roomListView.search(text: "kiwari")
    }
    
    func loadRoomList(){
        Qiscus.fetchAllRoom(onSuccess: { (rooms) in
            self.rooms = rooms
            self.tableview.rooms = rooms
            self.tableview.reloadData()
            
            Qiscus.subscribeAllRoomNotification()
        }, onError: { (error) in
            print("error")
        }) { (progress, loadedRoom, totalRoom) in
            print("progress: \(progress) [\(loadedRoom)/\(totalRoom)]")
        }
    }

}

extension ChatListVC : QRoomListDelegate {
    func didSelect(room: QRoom) {
        let chatView = Qiscus.chatView(withRoomId: room.id)
        chatView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    func didSelect(comment: QComment) {
        
    }
    
    // Uncoment this to use custom view cell
//    func tableviewCell() -> QRoomListCell? {
//        let cell = self.tableview.dequeueReusableCell(withIdentifier: "ChatListCell") as? ChatListCell
//        return cell
//    }
}
