//
//  NewStrangerVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/11/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit
import Qiscus

class NewStrangerVC: UIViewController {

    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneNumberEditingDidChanged(_ sender: UITextField) {
        guard let phoneNumber = sender.text else { return }
        let isEnable: Bool = (phoneNumber.count >= 9)
        self.isEnableButton(isEnable)
    }
}

extension NewStrangerVC {
    func setupUI() -> Void {
        self.title = "New Stranger"
        
        // add button in navigation right
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: self,
                                          action: #selector(starChat(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.isEnableButton(false)
        
        self.phoneField.becomeFirstResponder()
    }
    
    @objc func starChat(_ sender: Any) {
        guard let phoneNumber = self.phoneField.text else { return }
        let chatView = Qiscus.chatView(withUsers: [phoneNumber])
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    func isEnableButton(_ enable: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    }
}
