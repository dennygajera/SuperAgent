//
//  SettingsFilterViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 02.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import MessageUI

class SettingsFilterViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share() {
        self.sendEmail()
    }

}
