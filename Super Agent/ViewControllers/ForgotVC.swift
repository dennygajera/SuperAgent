//
//  ForgotVC.swift
//  Super Agent
//
//  Created by Darshan Gajera on 29/08/20.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import WebKit
class ForgotVC: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://mobilenotificationcleaner.com/")!
//        let url = URL(string: "https://google.com/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
