//
//  LoginVC.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/15/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UILoadingView {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    // show alert message while cannot connect with qiscus sdk
    var withMessage: String? {
        didSet {
            guard let message = withMessage else { return }
            if !(message.isEmpty) {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    self.showError(message: message)
                    Preference.instance.clearAll()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonDidTouchUpInside(_ sender: Any) {
        self.login()
    }
}

extension LoginVC {
    func setupUI() -> Void {
        self.title = "Login"
        
        // MARK: - Custom view & components
        let cornerRadius: CGFloat = 10.0
        self.mainView.layer.cornerRadius = cornerRadius
        self.loginButton.layer.cornerRadius = cornerRadius
        self.emailField.setBottomBorder()
        self.usernameField.setBottomBorder()
        self.passwordField.setBottomBorder()
        
        // MARK: - Set default fields
        self.emailField.text        = Helper.USER_EMAIL
        self.usernameField.text     = Helper.USER_USERNAME
        self.passwordField.text     = Helper.USER_PASSWORD
        
        self.emailField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }
    
    func login() {
        self.showWaiting(message: "Logged in...")
        guard let email = self.emailField.text else { return }
        guard let username = self.usernameField.text else { return }
        guard let password = self.passwordField.text else { return }
        let emailStr = email.replacingOccurrences(of: "[\\@.]",
                                                  with: "-",
                                                  options: .regularExpression,
                                                  range: nil)
        let avatarURL = "https://robohash.org/\(emailStr)/bgset_bg1/3.14159?set=set4"
        
        // save data in local storage for temporary
        if let data = PrefData(appId: Helper.APP_ID,
                               email: email,
                               password: password,
                               username: username,
                               avatarURL: avatarURL) {
            
            Preference.instance.setLocal(preference: data)
        }

        // start authenticate user
        let app = UIApplication.shared.delegate as! AppDelegate
        app.getBaseApp().validateUser()
    }

}
