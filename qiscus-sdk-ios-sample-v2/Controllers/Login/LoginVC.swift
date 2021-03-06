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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonDidTouchUpInside(_ sender: Any) {
        self.login()
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.actionOfReturnKey(textField.tag)
        return true
    }
}

extension LoginVC {
    func setupUI() -> Void {
        self.title = "Login"
        
        // MARK: - Delegation text field
        self.emailField.returnKeyType = .continue
        self.usernameField.returnKeyType = .continue
        self.passwordField.returnKeyType = .done
        
        self.emailField.delegate = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        
        // MARK: - Custom view & components
        let cornerRadius: CGFloat = 10.0
        self.mainView.layer.cornerRadius = cornerRadius
        self.loginButton.layer.cornerRadius = cornerRadius
        self.emailField.setBottomBorder()
        self.usernameField.setBottomBorder()
        self.passwordField.setBottomBorder()
        
        self.emailField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func actionOfReturnKey(_ tag: Int) {
        switch tag {
        case 0:
            self.usernameField.becomeFirstResponder()
            break
        case 1:
            self.passwordField.becomeFirstResponder()
            break
        case 2:
            self.login()
            break
        default:
            break
        }
    }
    
    func login() {
        self.dismissKeyboard()
        guard let email = self.emailField.text else { return }
        guard let username = self.usernameField.text else { return }
        guard let password = self.passwordField.text else { return }
        
//        if !(email.isValidEmail) {
//            self.showError(message: "Please input valid email!")
//            return
//        }
        
        self.showWaiting(message: "Logged in...")
        
        // save data in local storage
        if let data = PrefData(appId: Helper.APP_ID,
                               email: email,
                               password: password,
                               username: username,
                               avatarURL: email.getRandomAvatar()) {
            
            Preference.instance.setLocal(preference: data)
        }

        // start authenticate user
        let app = UIApplication.shared.delegate as! AppDelegate
        app.getBaseApp().validateUser()
    }

}
