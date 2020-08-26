//
//  MainViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switchConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var switchState: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "switchState")
        } set {
            UserDefaults.standard.set(newValue, forKey: "switchState")
        }
    }
    
    @IBAction func switchAction() {
        if !BlockManager.shared.isExtensionActive {
            self.showHint()
        } else {
            self.switchState = !self.switchState
            self.updateSwitch(true)
        }
        
        if switchState {
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
            self.activityIndicator.alpha = 1.0
            self.statusLabel.changeText(text: "Wait a minute")
            
            DispatchQueue.global().async {
                BlockManager.shared.activateFilters() { error in
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0.0
                    
                    if error == nil {
                        self.statusLabel.changeText(text: "Activated")
                    } else {
                        self.alert(title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
            }
        } else {
            DispatchQueue.global().async {
                BlockManager.shared.deactivateFilters() { error in
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0.0
                    
                    if error == nil {
                        self.statusLabel.changeText(text: "Disabled")
                    } else {
                        self.alert(title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateSwitch(false)
        
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
        
        if !BlockManager.shared.isFiltersDownloaded() {
            self.performSegue(withIdentifier: "welcome", sender: nil)
        }
        
        if BlockManager.shared.shouldReload {
            BlockManager.shared.shouldReload = false
            self.switchState = false
            self.updateSwitch(true)
            DispatchQueue.global().async {
                BlockManager.shared.deactivateFilters() { error in
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0.0
                    
                    if error == nil {
                        self.statusLabel.changeText(text: "Disabled")
                    } else {
                        self.alert(title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
    
    func updateSwitch(_ animate: Bool) {
        if animate {
            if switchState {
                UIView.animate(withDuration: 0.2) {
                    self.switchConstraint.constant = 73.0
                    self.view.layoutIfNeeded()
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.switchConstraint.constant = 0.0
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            if switchState {
                self.switchConstraint.constant = 73.0
            } else {
                self.switchConstraint.constant = 0.0
            }
        }
    }
    
    func showHint() {
        performSegue(withIdentifier: "hint", sender: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Constants.supportEmail])
            mail.setMessageBody("", isHTML: true)

            present(mail, animated: true)
        } else {
            self.alert(title: "Error", message: "Your need at least one email account is enabled")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func share() {
        self.sendEmail()
    }

}
