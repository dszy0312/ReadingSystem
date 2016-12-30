//
//  RegisterViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuserIdentifier = ["registerSuccessSegue", "reuserIdentifier"]

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //用户名
    @IBOutlet weak var usernameTF: UITextField!
    //验证码输入框
    @IBOutlet weak var YZMTF: UITextField!
    //密码输入框
    @IBOutlet weak var passwordTF: UITextField!
    //密码确认框
    @IBOutlet weak var rPasswordTF: UITextField!
    
    @IBOutlet weak var YZMButton: UILabel!
    
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
        if YZMButton.text == "验证码" {
            YZMRealButton.selected = false
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
            self.YZMRealButton.selected = true
            timer.invalidate()
            self.timer = nil
            self.YZMButton.alpha = 1
            self.YZMButton.text = "验证码"
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
        self.YZMButton.text = "\(time)秒"
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
                if flag == 1 {
                    self.YZM = dictionary!["msg"] as! String
                    self.YZMButton.alpha = 0.5
                    self.YZMButton.text = "\(self.time)秒"
                    self.startTime()
                } else {
                    alertMessage("系统提示", message: "验证失败，请重试！", vc: self)
                    self.YZMRealButton.selected = true
                }
            }
        }
    }
    
    func registerSend(username: String, password: String, YZM: String) {
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.registerNewUser.introduce(), parameter: ["phoneNumber": username, "password": password, "mobileYZHM": YZM]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                //2016.12.21修改，错误提示    魏辉
                alertMessage("系统提示", message: "\(error)", vc: self)
                return
            }
            
            let cookie = NetworkHealper.GetWithParm2.GetCookieStorage()
            for c in cookie.cookies! {
                if c.name == "LhApp_CurrentMember" {
                    let g = c.value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let d = NSKeyedArchiver.archivedDataWithRootObject(g!)
                    let h = NSKeyedUnarchiver.unarchiveObjectWithData(d)
                    if  let f = NSKeyedUnarchiver.unarchiveObjectWithData(d) as? String {
                        var data :NSData = f.dataUsingEncoding(NSUTF8StringEncoding)!
                        var json :NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: UInt(0))) as! NSDictionary
                        if let groupID = json["Group_ID"] as? Float{
                            NSUserDefaults.standardUserDefaults().setFloat(groupID, forKey: "groupID")
                        }
                    }
                }
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
    

}
