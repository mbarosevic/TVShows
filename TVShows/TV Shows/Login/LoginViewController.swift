//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 11.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire

struct LoginUser: Codable {
    let email: String
    let imageUrl: String?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}

struct LoginResponse: Codable {
    let user: LoginUser
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var emailInputTextField: UITextField!
    @IBOutlet private weak var passwordInputTextField: UITextField!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    private var rememberMe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedEdgesToTheLoginButton()
        updateDesignOfUITextField()
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
            showAlert(display: "Please enter username")
        } else if passwordTextFieldValue == "" {
            showAlert(display: "Please enter password")
        } else {
            print("username: \(emailTextFieldValue)")
            print("pw: \(passwordTextFieldValue)")
            signIn(email: emailTextFieldValue, password: passwordTextFieldValue)
        }
    }
    
    @IBAction func touchRegisterButton() {
        let emailTextFieldValue = emailInputTextField.text ?? ""
        let passwordTextFieldValue = passwordInputTextField.text ?? ""
        
        if emailTextFieldValue == "" {
            showAlert(display: "Please enter username")
        } else if passwordTextFieldValue == "" {
            showAlert(display: "Please enter password")
        } else {
            print("username: \(emailTextFieldValue)")
            print("pw: \(passwordTextFieldValue)")
            register(email: emailTextFieldValue, password: passwordTextFieldValue)
        }
    }
    
    private func showAlert(display message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addRoundedEdgesToTheLoginButton() {
        loginButton.layer.cornerRadius = 21.5
    }
    
    private func updateDesignOfUITextField() {
        emailInputTextField.setLeftPaddingPoints(10)
        passwordInputTextField.setLeftPaddingPoints(10)

        setBottomLine(to: emailInputTextField)
        setBottomLine(to: passwordInputTextField)
        
        setPlaceholderText(to: emailInputTextField, value: "ios.team@infinum.com")
        setPlaceholderText(to: passwordInputTextField, value: "••••••••••")
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
    
    private func signIn(email: String, password: String) {
        let params: [String: String] = [
                    "email": email,
                    "password": password,
                    ]
        SVProgressHUD.show()
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let response):
                    print("OK \(response)")
                case .failure(let error):
                    print("Error2 \(error)")
                }
            }
    }
    
    private func register(email: String, password: String) {
        let params: [String: String] = [
                    "email": email,
                    "password": password,
                    "password_confirmation": password
                    ]
        SVProgressHUD.show()
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let response):
                    print("OK \(response)")
                case .failure(let error):
                    print("Error2 \(error)")
                }
            }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
