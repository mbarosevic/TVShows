//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 11.07.2021..
//

import Foundation
import UIKit

final class LoginViewController: UIViewController, APIManagerDelegate {
    
    private var loggedInUser: User?
    private var rememberMe: Bool = false
    @IBOutlet private weak var emailInputTextField: UITextField!
    @IBOutlet private weak var passwordInputTextField: UITextField!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesignChanges()
        APIManager.self.shared().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction private func touchRememberMeCheckbox() {
        if !rememberMe {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .normal)
            self.rememberMe = true
        } else {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
            self.rememberMe = false
        }
    }
    
    @IBAction func touchLoginButton() {
        let emailTextFieldValue = emailInputTextField.text ?? ""
        let passwordTextFieldValue = passwordInputTextField.text ?? ""
        
        if emailTextFieldValue == "" {
            showAlertWith(message: "Please enter your email")
        } else if passwordTextFieldValue == "" {
            showAlertWith(message: "Please enter your password")
        } else {
            APIManager.self.shared().loginUserWith(email: emailTextFieldValue, password: passwordTextFieldValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if self.checkAPIResponse(for: self.loggedInUser ?? User.init(email: "", imageUrl: "", id: "")){
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }
        })
    }
     
    @IBAction func touchRegisterButton() {
        let emailTextFieldValue = emailInputTextField.text ?? ""
        let passwordTextFieldValue = passwordInputTextField.text ?? ""
        
        if emailTextFieldValue == "" {
            showAlertWith(message: "Please enter your email")
        } else if passwordTextFieldValue == "" {
            showAlertWith(message: "Please enter your password")
        } else {
            APIManager.self.shared().registerUserWith(email: emailTextFieldValue, password: passwordTextFieldValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if self.checkAPIResponse(for: self.loggedInUser ?? User.init(email: "", imageUrl: "", id: "")){
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }
        })
    }
    
    private func checkAPIResponse(for userData: User) -> Bool {
        if userData.email != "" && userData.id != "" {
            return true
        } else {
            return false
        }
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func applyDesignChanges() {
        emailInputTextField.setLeftPaddingPoints(10)
        passwordInputTextField.setLeftPaddingPoints(10)

        setBottomLine(to: emailInputTextField)
        setBottomLine(to: passwordInputTextField)
        
        setPlaceholderText(to: emailInputTextField, value: "ios.team@infinum.com")
        setPlaceholderText(to: passwordInputTextField, value: "••••••••••")
        
        loginButton.addRoundedEdgesToTheLoginButton(21.5)
    }
    
    private func setBottomLine(to textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(
            x: 0.0,
            y: textField.frame.height - 1,
            width: textField.frame.width,
            height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
    }
    
    private func setPlaceholderText(to textField: UITextField, value: String) {
        textField.attributedPlaceholder = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func setLoginDataFor(_ user: User?) {
        self.loggedInUser = user
        
        print("Logged In User: \(user?.email ?? "Nema ga")")
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIButton {
    func addRoundedEdgesToTheLoginButton(_ amount: CGFloat) {
        self.layer.cornerRadius = amount
    }
}
