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
    @IBOutlet weak var tapToIncrementBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedEdgesToTheButton()
        autoStartActivityIndicator()
        //displaySVProgressHUD()
    }
    
    func addRoundedEdgesToTheButton() {
        tapToIncrementBtn.layer.cornerRadius = 20
        tapToIncrementBtn.layer.borderWidth = 0.2
        tapToIncrementBtn.layer.borderColor = UIColor.gray.cgColor
    }
    
    func autoStartActivityIndicator(){
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [self] in
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
    }
    
    func startStopActivityIndicator() {
        if(loadingIndicator.isHidden) {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    
    // Display progress HUD for 5 seconds
    func displaySVProgressHUD() {
        // Simple SVProgressHUD example, a dispatch queue dismisses the progress hud after 5 seconds of displayed progress hud
        // A great use case is to display progress hud after Login btn click and while API call is being performed
        
        SVProgressHUD.show()
        // Closure
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        startStopActivityIndicator()
        // Console output
        print("Button tapped")
        
        // numberOfTaps variable increment on each tap of button
        numberOfTaps += 1
        numberOfTapsLabel.text = String(numberOfTaps)
    }
}
