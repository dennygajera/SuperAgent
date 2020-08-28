//
//  InfoViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func terms() {
        if let url = URL(string: Constants.Links.termsOfUse) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacy() {
        if let url = URL(string: Constants.Links.privacyPolicy) {
            UIApplication.shared.open(url)
        }
    }
    
//    @IBAction func subscribe() {
//        performSegue(withIdentifier: "subscribe", sender: nil)
//    }
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
}
