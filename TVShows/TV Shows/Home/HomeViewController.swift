//
//  HomeViewController.swift
//  TV Shows
//
//  Created by FOI on 20.07.2021..
//

import Foundation
import UIKit
final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home screen loaded")
        
        if let usermail = UserData.sharedInstance.user?.email {
            print(usermail)
        } else {
            print("Greska u radu")
        }
    }
}
