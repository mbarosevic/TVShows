//
//  AccountViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 02.08.2021..
//

import Foundation
import UIKit
final class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyAccount screen")
    }
    
    @IBAction func logoutUser() {
        KeychainManager.shared.deleteKeychainValues()
        UserData.sharedInstance.authInfo = nil
        
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
