//
//  ReplaceViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ReplaceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var YZMTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var rPasswordTF: UITextField!
    
    @IBOutlet weak var YZMLabel: UILabel!
    @IBOutlet weak var YZMRealButton: UIButton!
    
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
    
    @IBAction func getYZMClick(sender: UIButton) {
        
        guard usernameTF.text != "" else {
            alertMessage("系统提示", message: "手机号不能为空！", vc: self)
            return
        }
        guard usernameTF.text?.characters.count == 11 else {
            alertMessage("系统提示", message: "请填写正确的手机号！", vc: self)
            return
        }
        if YZMLabel.text == "验证码" {
            YZMRealButton.selected = false
            YZMLabel.alpha = 0.5
            startTime()
            getYZM(usernameTF.text!)
        }

    }
    
    @IBAction func resetClick(sender: UIButton) {
        guard YZMTF.text == self.YZM else {
            alertMessage("系统提示", message: "验证码错误！", vc: self)
            return
        }
        guard passwordTF.text == rPasswordTF.text else {
            alertMessage("系统提示", message: "密码设置错误！", vc: self)
            return
        }
        resetSend(usernameTF.text!, password: passwordTF.text!, YZM: YZMTF.text!)
    }

    
    @IBAction func backClick(sender: UIButton) {
        usernameTF.resignFirstResponder()
        YZMTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        rPasswordTF.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
            self.YZMLabel.alpha = 1
            self.YZMLabel.text = "验证码"
            self.time = 60
        }
    }
    //时间切换
    @objc private func exchange() {
        guard time > 0 else {
            endTime()
            return
        }
        time -= 1
        self.YZMLabel.text = "\(time)秒"
    }
    //textFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        YZMTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        rPasswordTF.resignFirstResponder()
        return true
    }


    
    //MARK:网络请求
    func getYZM(username: String) {
        
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.getYZHM.introduce(), parameter: ["mobile": username]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                alertMessage("系统提示", message: "发送失败，请重试！", vc: self)
                self.YZMRealButton.selected = true
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                print(flag)
                if flag == 1 {
                    self.YZM = dictionary!["msg"] as! String
                    self.YZMLabel.alpha = 0.5
                    self.YZMLabel.text = "\(self.time)秒"
                    self.startTime()
                } else {
                    alertMessage("系统提示", message: "验证失败，请重试！", vc: self)
                    self.YZMRealButton.selected = true
                }
            }

        }
    }
    
    func resetSend(username: String, password: String, YZM: String) {
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.resetPassword.introduce(), parameter: ["phoneNumber": username, "password": password, "mobileYZHM": YZM]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    alertMessage("系统提示", message: "发送失败，请重试！", vc: self)
                }
            }
        }
    }

    
    
}
