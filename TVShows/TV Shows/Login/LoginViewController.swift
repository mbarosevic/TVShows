//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 11.07.2021..
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var numberOfTapsLabel: UILabel!
    var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        // Console output
        print("Button tapped")
        
        // numberOfTaps variable increment on each tap of button
        numberOfTaps += 1
        numberOfTapsLabel.text = String(numberOfTaps)
    }
}
