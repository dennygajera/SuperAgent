//
//  AppDelegate.swift
//  Super Agent
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SafariServices
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController.navigationBar.isHidden = true
        let userSession = UserDefaults.standard.bool(forKey: "UserActive")
        if userSession {
            let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
               navigationController.viewControllers = [rootViewController]
               self.window?.rootViewController = navigationController
        } else {
            let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "ActivationVC") as! ActivationVC
               navigationController.viewControllers = [rootViewController]
               self.window?.rootViewController = navigationController
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let id = Config.App.extensionBundleId
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
            DispatchQueue.main.async {
                if state?.isEnabled ?? false {
                    BlockManager.shared.isExtensionActive = true
                } else {
                    BlockManager.shared.isExtensionActive = false
                }
            }
        })
    }
}

