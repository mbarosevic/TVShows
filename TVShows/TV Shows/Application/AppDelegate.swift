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
        print("User data from keychain::::")
        print(KeychainManager.shared.accessToken)
        print(KeychainManager.shared.client)
        print(KeychainManager.shared.tokenType)
        print(KeychainManager.shared.expiry)
        print(KeychainManager.shared.uid)
        let params: [String: String] = [
                    "access-token": KeychainManager.shared.accessToken,
                    "client": KeychainManager.shared.client,
                    "token-type": KeychainManager.shared.tokenType,
                    "expiry": KeychainManager.shared.expiry,
                    "uid": KeychainManager.shared.uid
                ]
        
        do {
            if !KeychainManager.shared.accessToken.isEmpty {
                UserData.sharedInstance.authInfo = try AuthInfo.init(headers: params)
                GotoShowsScreen()
            }
        } catch let error {
            print("error: \(error)")
        }

        return true
    }
    
    private func GotoShowsScreen() {
        let navigationController = UINavigationController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Shows", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ShowsViewController.self)) as! ShowsViewController
        
        navigationController.setViewControllers([homeViewController], animated: true)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

