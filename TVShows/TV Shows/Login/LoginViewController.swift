//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 11.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailInputTextField: UITextField!
    @IBOutlet private weak var passwordInputTextField: UITextField!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var loggedInUser: User?
    private var rememberMe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesignChanges()
        
        emailInputTextField.text = "mbarosevic@gmail.com"
        passwordInputTextField.text = "tester1234"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction private func touchRememberMeCheckbox() {
        if !rememberMe {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .normal)
            rememberMe = true
        } else {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
            rememberMe = false
        }
    }
    
    @IBAction func didTapLoginButton() {
        guard let email = emailInputTextField.text, !email.isEmpty else {
            showAlertWith(message: "Please enter your email")
            return
        }
        
        guard let password = passwordInputTextField.text, !password.isEmpty else {
            showAlertWith(message: "Please enter your password")
            return
        }
        
        SVProgressHUD.show()
        APIManager.shared.loginUser(
            with: UserParameters(password: password, email: email),
            completion: { [self] dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    loggedInUser = response.user
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    handleSuccesfulLogin(for: response.user, headers: headers)
                case .failure(let error):
                    print("Error \(error)")
                    showAlertWith(message: "Login failed")
                }
            }
        )
    }
     
    @IBAction func didTapRegisterButton() {
        guard let email = emailInputTextField.text, !email.isEmpty else {
            showAlertWith(message: "Please enter your email")
            return
        }
        
        guard let password = passwordInputTextField.text, !password.isEmpty else {
            showAlertWith(message: "Please enter your password")
            return
        }
        
        SVProgressHUD.show()
        APIManager.shared.registerUser(
            with: UserParameters(password: password, email: email),
            completion: { [self] dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    loggedInUser = response.user
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    handleSuccesfulLogin(for: response.user, headers: headers)
                case .failure(let error):
                    print("Error \(error)")
                    showAlertWith(message: "Registration failed")
                }
            }
        )
    }
    
    private func checkAPIResponse(for userData: User) -> Bool {
        if userData.email != "" && userData.id != "" {
            return true
        } else {
            return false
        }
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func applyDesignChanges() {
        emailInputTextField.setLeftPadding(equalTo: 10)
        passwordInputTextField.setLeftPadding(equalTo: 10)

        emailInputTextField.setBottomLine()
        passwordInputTextField.setBottomLine()

        setPlaceholderText(to: emailInputTextField, value: "ios.team@infinum.com")
        setPlaceholderText(to: passwordInputTextField, value: "••••••••••")
        
        loginButton.applyCornerRadius(of: 21.5)
    }
    
    private func setPlaceholderText(to textField: UITextField, value: String) {
        textField.attributedPlaceholder = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }

    private func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        
        guard let loginInfo = try? User(email: user.email, imageUrl: user.imageUrl ?? "", id: user.id) else {
            SVProgressHUD.showError(withStatus: "Missing user details")
            return
        }
        UserData.sharedInstance.user = loginInfo
        UserData.sharedInstance.authInfo = authInfo
        goToHomeScreen()
    }
    
    private func goToHomeScreen() {
        let storyboard = UIStoryboard(name: "Home", bundle: .main)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "Shows") as! ShowsViewController
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

extension UITextField {
    func setLeftPadding(equalTo amount: CGFloat){
        let paddingView = UIView(frame: CGRect(
                                    x: 0,
                                    y: 0,
                                    width: amount,
                                    height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

extension UITextField {
    func setBottomLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(
            x: 0.0,
            y: frame.height - 1,
            width: frame.width,
            height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

extension UIButton {
    func applyCornerRadius(of radius: CGFloat) {
        layer.cornerRadius = radius
    }
}
