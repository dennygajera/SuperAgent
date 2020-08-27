//
//  ActivationVC.swift
//  Super Agent
//
//  Created by Darshan Gajera on 26/08/20.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class ActivationVC: UIViewController {

    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
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
    
    func navigateToMain() {
        performSegue(withIdentifier: "activate", sender: nil)
    }
}
