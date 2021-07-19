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

    @IBOutlet private weak var showNumberOfTapsLabel: UILabel!
    @IBOutlet private weak var touchCounterButton: UIButton!
    @IBOutlet private weak var changeStateButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private var numberOfClicks: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedEdgesToTheButton()
        autoStartActivityIndicator()
        //displaySVProgressHUD()
    }
    
    private func addRoundedEdgesToTheButton() {
        touchCounterButton.layer.cornerRadius = 20
        touchCounterButton.layer.borderWidth = 0.2
        touchCounterButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func autoStartActivityIndicator(){
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [self] in
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
    }
    
    private func startStopActivityIndicator() {
        if loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            changeStateButton.setTitle("Start", for: .normal)
        } else {
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            changeStateButton.setTitle("Stop", for: .normal)
        }
    }
    
    // Display progress HUD for 5 seconds
    private func displaySVProgressHUD() {
        // Simple SVProgressHUD example, a dispatch queue dismisses the progress hud after 5 seconds of displayed progress hud
        // A great use case is to display progress hud after Login btn click and while API call is being performed
        
        SVProgressHUD.show()
        // Closure
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction private func buttonActionHandler() {
        // Console output
        print("Button tapped")
        
        // numberOfTaps variable increment on each tap of button
        numberOfClicks += 1
        showNumberOfTapsLabel.text = String(numberOfClicks)
    }
    
    @IBAction private func changeActivityIndicatorVisibilityButton() {
        startStopActivityIndicator()
    }
}
