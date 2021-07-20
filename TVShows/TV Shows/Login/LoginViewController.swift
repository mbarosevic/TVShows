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

    @IBOutlet private weak var usernameInputTextField: UITextField!
    @IBOutlet private weak var passwordInputTextField: UITextField!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    private var rememberMe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedEdgesToTheLoginButton()
        updateDesignOfUITextField()
        //signIn()
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
    
    private func addRoundedEdgesToTheLoginButton() {
        loginButton.layer.cornerRadius = 21.5
    }
    
    private func updateDesignOfUITextField() {
        usernameInputTextField.setLeftPaddingPoints(10)
        passwordInputTextField.setLeftPaddingPoints(10)

        setBottomLine(to: usernameInputTextField)
        setBottomLine(to: passwordInputTextField)
        
        setPlaceholderText(to: usernameInputTextField, value: "ios.team@infinum.com")
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
    
    private func signIn() {
        let params: [String: String] = [
                    "email": "mbarosevic@gmail.com",
                    "password": "tester1234",
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
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
