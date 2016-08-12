//
//  LoginViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        usernameTF.delegate = self
        passwordTF.delegate = self
        
        
        
//        transitionDelegate.animationTransition.pointFrame =
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == usernameTF {
            UIView.animateWithDuration(0.5, animations: { 
                self.usernameLabel.center.x += self.view.frame.width / 2
                self.usernameLabel.alpha = 0
            })
            
        } else if textField == passwordTF {
            UIView.animateWithDuration(0.5, animations: {
                self.passwordLabel.center.x += self.view.frame.width / 2
                self.passwordLabel.alpha = 0
                }, completion: { (_) in
                    self.passwordLabel.center = self.passwordTF.center
                    self.passwordLabel.textAlignment = NSTextAlignment.Right
                    self.passwordLabel.text = "6~12"
                    self.passwordLabel.alpha = 1
            })
        }
    }
    
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
