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
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOTP3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                txtOTP1.becomeFirstResponder()
    }
    
}

extension ActivationVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 3 {
            switch textField{
            case txtOTP1:
                txtOTP2.becomeFirstResponder()
            case txtOTP2:
                txtOTP3.becomeFirstResponder()
            case txtOTP3:
                txtOTP3.becomeFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txtOTP1:
                txtOTP1.becomeFirstResponder()
            case txtOTP2:
                txtOTP1.becomeFirstResponder()
            case txtOTP3:
                txtOTP2.becomeFirstResponder()
            default:
                break
            }
        }
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
        let dic = ["transactionID":"\(txtOTP1.text)-\(txtOTP2.text)-\(txtOTP3.text)"]
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
