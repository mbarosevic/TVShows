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
    @IBOutlet private weak var registerButton: UIButton!
    
    private var loggedInUser: User?
    private var rememberMe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesignChanges()
        
        #if DEBUG
        emailInputTextField.text = "mbarosevic@gmail.com"
        passwordInputTextField.text = "tester1234"
        #endif
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
    
    @IBAction private func didTapLoginButton() {
        guard let email = emailInputTextField.text, !email.isEmpty else {
            self.showFailure(with: "Error", message: "Please enter your email")
            return
        }
        
        guard let password = passwordInputTextField.text, !password.isEmpty else {
            self.showFailure(with: "Error", message: "Please enter your password")
            return
        }
        
        self.showLoading()
        APIManager.shared.loginUser(
            with: UserParameters(password: password, email: email),
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    self.loggedInUser = response.user
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: response.user, headers: headers, storeData: self.rememberMe)
                case .failure:
                    self.loginButton.shake()
                }
            }
        )
    }
     
    @IBAction private func didTapRegisterButton() {
        guard let email = emailInputTextField.text, !email.isEmpty else {
            self.showFailure(with: "Error", message: "Please enter your email")
            return
        }
        
        guard let password = passwordInputTextField.text, !password.isEmpty else {
            self.showFailure(with: "Error", message: "Please enter your password")
            return
        }
        
        self.showLoading()
        APIManager.shared.registerUser(
            with: UserParameters(password: password, email: email),
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    self.loggedInUser = response.user
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: response.user, headers: headers, storeData: self.rememberMe)
                case .failure:
                    self.registerButton.shake()
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

    private func handleSuccesfulLogin(for user: User, headers: [String: String], storeData: Bool) {
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
        
        if storeData {
            // store authInfo and loginInfo in keychain
            saveDataInKeychain(authInfo: authInfo)
        }
        
        goToHomeScreen()
    }
    
    func saveDataInKeychain(authInfo: AuthInfo) {
        KeychainManager.shared.accessToken = authInfo.accessToken
        KeychainManager.shared.client = authInfo.client
        KeychainManager.shared.tokenType = authInfo.tokenType
        KeychainManager.shared.expiry = authInfo.expiry
        KeychainManager.shared.uid = authInfo.uid
    }
    
    private func goToHomeScreen() {
        let storyboard = UIStoryboard(name: "Shows", bundle: .main)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ShowsViewController.self)) as! ShowsViewController
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
    
    func shake() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
            layer.add(animation, forKey: "shake")
        }
}

extension LoginViewController: ProgressReporting {
    
}
