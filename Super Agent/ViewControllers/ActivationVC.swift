//
//  ActivationVC.swift
//  Super Agent
//
//  Created by Darshan Gajera on 26/08/20.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import SPAlert

class ActivationVC: UIViewController {
    
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //        txtOTP1.delegate = self
        //        txtOTP2.delegate = self
        //        txtOTP3.delegate = self
        //        txtOTP1.becomeFirstResponder()
    }
    
}

extension ActivationVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! >= 2 ) && (string.count > 0) {
            if textField == txtOTP1 {
                txtOTP2.becomeFirstResponder()
            }
            
            if textField == txtOTP2 {
                txtOTP3.becomeFirstResponder()
            }
            
            if textField == txtOTP3 {
                txtOTP3.becomeFirstResponder()
            }
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 3) && (string.count == 0) {
            if textField == txtOTP2 {
                txtOTP1.becomeFirstResponder()
            }
            if textField == txtOTP3 {
                txtOTP2.becomeFirstResponder()
            }
            if textField == txtOTP1 {
                txtOTP1.resignFirstResponder()
            }
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 3 {
            textField.text = string
            return false
        }
        return true
    }
    
    @IBAction func btnForgotClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotVC") as! ForgotVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActiveClick(_ sender: UIButton) {
        if txtOTP1.text == "" || txtOTP2.text == "" || txtOTP3.text == "" {
            SPAlert.present(message: "Activation code required")
        } else {
            self.wsCall { (result) in
                if result! {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let alertView = SPAlertView(title: "Wrong Activation code", message: nil, preset: .exclamation)
                        alertView.duration = 2
                        alertView.present()
                    }
                    
                }
            }
            
        }
    }
    
    func wsCall(block: @escaping (Bool?) -> Void) {
        let dic = ["transactionID":"733-UMK-674"]
        ServiceManager.sharedInstance.postRequest(parameterDict: dic, URL: APINAME().ACTIVATIONCODE) { (dicResult, err) in
            let status = dicResult?.value(forKey: "isActive") as! Int
            if status == 1 {
                block(true)
            } else {
                block(false)
            }
        }
    }
}
