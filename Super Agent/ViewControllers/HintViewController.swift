//
//  HintViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import SafariServices

class HintViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        // Application is back in the foreground
        
        let id = Config.App.extensionBundleId
        
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
            DispatchQueue.main.async {
                if state?.isEnabled ?? false {
                    self.close()
                    BlockManager.shared.isExtensionActive = true
                }
            }
        })
    }
    

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
