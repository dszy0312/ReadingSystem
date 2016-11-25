//
//  RegisterViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuserIdentifier = ["registerSuccessSegue"]

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var YZMTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var rPasswordTF: UITextField!
    
    @IBOutlet weak var YZMButton: UIButton!
    
    
    //验证码
    var YZM = ""
    //自动跳转
    var timer: NSTimer!
    //60秒计时
    var time = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        YZMTF.delegate = self
        passwordTF.delegate = self
        rPasswordTF.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.endTime()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuserIdentifier[0] {
            let toVC = segue.destinationViewController as! PersonalCenterViewController
            
        }
    }
    

    @IBAction func backClick(sender: UIButton) {
        usernameTF.resignFirstResponder()
        YZMTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        rPasswordTF.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func getYZMClick(sender: UIButton) {
        guard usernameTF.text != "" else {
            alertMessage("系统提示", message: "手机号不能为空！", vc: self)
            return
        }
        guard usernameTF.text?.characters.count == 11 else {
            alertMessage("系统提示", message: "请填写正确的手机号！", vc: self)
            return
        }
        if sender.titleLabel?.text == "验证码" {
            getYZM(usernameTF.text!)
            
        }
    }
    
    @IBAction func registerClick(sender: UIButton) {
        guard YZMTF.text == self.YZM else {
            alertMessage("系统提示", message: "验证码错误！", vc: self)
            return
        }
        guard passwordTF.text == rPasswordTF.text else {
            alertMessage("系统提示", message: "密码设置错误！", vc: self)
            return
        }
        registerSend(usernameTF.text!, password: passwordTF.text!, YZM: YZMTF.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        YZMTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        rPasswordTF.resignFirstResponder()
        return true
    }
    
    //倒数读秒
    func startTime() {
        guard self.timer == nil else {
            self.timer = nil
            return
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(exchange), userInfo: nil, repeats: true)
    }
    func endTime() {
        if timer != nil {
            timer.invalidate()
            self.timer = nil
            self.YZMButton.alpha = 1
            self.YZMButton.setTitle("验证码", forState: UIControlState.Normal)
            self.time = 60
        }
    }
    //移动图片位置
    @objc private func exchange() {
        guard time > 0 else {
            endTime()
            return
        }
        time -= 1
        self.YZMButton.setTitle("\(time)秒", forState: UIControlState.Normal)
    }

    
    
    //MARK:网络请求
    func getYZM(username: String) {
        
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.getYZHM.introduce(), parameter: ["mobile": username, "type": "register"]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                print(flag)
                if flag == 1 {
                    self.YZM = dictionary!["msg"] as! String
                    self.YZMButton.alpha = 0.5
                    self.YZMButton.setTitle("\(self.time)秒", forState: UIControlState.Normal)
                    self.startTime()
                } else {
                    if let msg = dictionary!["msg"] as? String {
                        alertMessage("系统提示", message: msg, vc: self)
                    }
                    print("发送失败")
                }
            }
        }
    }
    
    func registerSend(username: String, password: String, YZM: String) {
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.registerNewUser.introduce(), parameter: ["phoneNumber": username, "password": password, "mobileYZHM": YZM]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.userSet(username, icon: "center_photo")
                    self.performSegueWithIdentifier(reuserIdentifier[0], sender: self)
                } else {
                    alertMessage("系统提示", message: "发送失败，请重试！", vc: self)
                }
            }
        }
    }
    
    func userSet(username: String, icon: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "userTitle")
        NSUserDefaults.standardUserDefaults().setObject(icon, forKey: "userImage")
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
