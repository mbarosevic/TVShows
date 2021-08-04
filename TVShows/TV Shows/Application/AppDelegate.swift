//
//  AppDelegate.swift
//  TVShows
//
//  Created by FOI on 08.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
         
         CHECK THE Keychain
         IF User selects remember me option, store the values in Keychain
         
         The same works for logout, but remove the values from keychain
         
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Shows", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ShowsViewController.self)) as! ShowsViewController
        self.window?.rootViewController = homeViewController
        self.window?.makeKeyAndVisible()
        */
        return true
    }
}

