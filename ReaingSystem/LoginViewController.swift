//
//  LoginViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

protocol LoginDelegate {
    func sendIndexs(name: String, icon: String)
}
private var reuserIdentifier = ["RegisterSegue"]

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var loginDelegate: LoginDelegate!
    

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
        UIApplication.sharedApplication().statusBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == usernameTF {
            UIView.animateWithDuration(0.5, animations: {
                self.usernameLabel.center.x += self.view.frame.width
                self.usernameLabel.alpha = 0
            })
            
        } else if textField == passwordTF {
            UIView.animateWithDuration(0.5, animations: {
                self.passwordLabel.center.x += self.view.frame.width
                self.passwordLabel.alpha = 0
                }, completion: { (_) in
            })
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    
    @IBAction func sinaClick(sender: UIButton) {
        otherLogin(SSDKPlatformType.TypeSinaWeibo)
    }
    
    @IBAction func qqClick(sender: UIButton) {
        ShareSDK.getUserInfo(SSDKPlatformType.TypeQQ) { (state, user, error) in
            if (state == SSDKResponseState.Success)
            {
                //头像
                var icon: String!
                //原始数据
                print("这是：\(user.rawData)")
                
                if let ic = user.rawData["figureurl_qq_2"] as? String {
                    icon = ic
                } else {
                    icon = user.icon
                }
                self.otherLoginSend(user.uid, nickName: user.nickname, userType: 2, uuid: self.checkUuid()!, icon: icon)
            }
            else
            {
                if error != nil {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func wechatClick(sender: UIButton) {
        otherLogin(SSDKPlatformType.TypeWechat)
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginClick(sender: UIButton) {
        guard usernameTF.text != "" else {
            alertMessage("系统提示", message: "用户名不能为空！", vc: self)
            return
        }
        guard passwordTF.text != "" else {
            alertMessage("系统提示", message: "密码不能为空！", vc: self)
            return
        }
        print(checkUuid())
        loginSend(usernameTF.text!, password: passwordTF.text!, uuid: checkUuid()!)
    }
    
    
    @IBAction func registerClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuserIdentifier[0], sender: self)
    }
    
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
    
    //UUID查询
    func checkUuid() -> String?{
        // keyChain group
        var service = "com.weihui.ReaingSystem"
        // access group
        var group = ""
        // 查询name
        let kReadingUUIDKey = "UUIDKey"
        var keychain: KeychainUtility?
        // 发布者身份检查 可以实现不同APP调用
        guard let appIdPrefix = NSBundle.mainBundle().infoDictionary!["AppIdentifierPrefix"] as? String else {
            print("No AppIdPrefix")
            return nil
        }
        group = appIdPrefix + service
        keychain = KeychainUtility(service: service, group: group)
        // 查询钥匙串中是否有存储的UUID
        if let data = keychain?.query(kReadingUUIDKey) {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        } else {
            return nil
        }
    }
    
    //第三方登陆
    func otherLogin(type: SSDKPlatformType) {
        var types = 0
        switch type {
        case SSDKPlatformType.TypeQQ:
            types = 2
        case SSDKPlatformType.TypeWechat:
            types = 3
        case SSDKPlatformType.TypeSinaWeibo:
            types = 4
        default:
            break
        }
        ShareSDK.getUserInfo(type) { (state, user, error) in
            if (state == SSDKResponseState.Success)
            {
                self.otherLoginSend(user.uid, nickName: user.nickname, userType: types, uuid: self.checkUuid()!, icon: user.icon)
            }
            else
            {
                if error != nil {
                    print(error)
                }
            }
        }
    }

    
    //MARK:网络请求
    func loginSend(username: String, password: String, nickName: String = "", userType: Int = 1, uuid: String) {
        
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.login.introduce(), parameter: ["userName": username, "password": password, "nickName": nickName, "userType": userType, "uuid": uuid]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            let cookie = NetworkHealper.GetWithParm2.GetCookieStorage()
            for c in cookie.cookies! {
                if c.name == "LhApp_CurrentMember" {
                    let g = c.value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let d = NSKeyedArchiver.archivedDataWithRootObject(g!)
                    let h = NSKeyedUnarchiver.unarchiveObjectWithData(d)
                    if  let f = NSKeyedUnarchiver.unarchiveObjectWithData(d) as? String {
                        print(f)
                        var data :NSData = f.dataUsingEncoding(NSUTF8StringEncoding)!
                        var json :NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: UInt(0))) as! NSDictionary
                        if let groupID = json["Group_ID"] as? Float{
                            NSUserDefaults.standardUserDefaults().setFloat(groupID, forKey: "groupID")
                            print(groupID)
                        }
                    }
                }
        }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.userSet(username, icon: "center_photo")
                    //清除之前的下载记录
                    let realm = try! Realm()
                    let books = realm.objects(MyShelfRmBook).filter("isOnShelf == %@", 1)
                    let allBooks = realm.objects(MyShelfRmBook)
                    try! realm.write({
                        books.setValue(false, forKey: "downLoad")
                        books.setValue(0, forKey: "isOnShelf")
                        allBooks.setValue(1, forKey: "readedPage")
                    })
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    alertMessage("登陆失败", message: "请检查用户名和密码是否正确", vc: self)
                    print("发送失败")
                }
            }
        }
    }
    
    func otherLoginSend(username: String, password: String = "", nickName: String, userType: Int, uuid: String, icon: String) {
        
        NetworkHealper.GetWithParm2.receiveJSON(URLHealper.login.introduce(), parameter: ["userName": username, "password": password, "nickName": nickName, "userType": userType, "uuid": uuid]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            
            let cookie = NetworkHealper.GetWithParm2.GetCookieStorage()
            for c in cookie.cookies! {
                if c.name == "LhApp_CurrentMember" {
                    let g = c.value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let d = NSKeyedArchiver.archivedDataWithRootObject(g!)
                    let h = NSKeyedUnarchiver.unarchiveObjectWithData(d)
                    if  let f = NSKeyedUnarchiver.unarchiveObjectWithData(d) as? String {
                        print(f)
                        var data :NSData = f.dataUsingEncoding(NSUTF8StringEncoding)!
                        var json :NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: UInt(0))) as! NSDictionary
                        if let groupID = json["Group_ID"] as? Float{
                            NSUserDefaults.standardUserDefaults().setFloat(groupID, forKey: "groupID")
                            print(groupID)
                        }
                    }
                }
            }
            
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.userSet(nickName, icon: icon)
                    //清除之前的下载记录
                    let realm = try! Realm()
                    let books = realm.objects(MyShelfRmBook).filter("isOnShelf == %@", 1)
                    let allBooks = realm.objects(MyShelfRmBook)
                    try! realm.write({
                        books.setValue(false, forKey: "downLoad")
                        books.setValue(0, forKey: "isOnShelf")
                        allBooks.setValue(1, forKey: "readedPage")
                    })
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    alertMessage("登陆失败", message: "请重试！", vc: self)
                    print("发送失败")
                }
            }
        }
    }
    
    
    func userSet(username: String, icon: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "userTitle")
        NSUserDefaults.standardUserDefaults().setObject(icon, forKey: "userImage")
    }
    


   

}
