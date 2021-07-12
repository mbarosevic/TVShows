//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 11.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var numberOfTapsLabel: UILabel!
    var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Simple SVProgressHUD example, a dispatch queue dismisses the progress hud after 5 seconds of displayed progress hud
        // A great use case is to display progress hud after Login btn click and while API call is being performed
        
        //SVProgressHUD.show()
        // Closure
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5){
        //    SVProgressHUD.dismiss()
        //}
    }
    
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        // Console output
        print("Button tapped")
        
        // numberOfTaps variable increment on each tap of button
        numberOfTaps += 1
        numberOfTapsLabel.text = String(numberOfTaps)
    }
}
