//
//  AppDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/7/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyBoard: UIStoryboard?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.makeKeyAndVisible()
//        
//        storyBoard = UIStoryboard(name: "Paper", bundle: nil)
//        let rootController = storyBoard?.instantiateViewControllerWithIdentifier("PaperDetail")
//        
//        if let window = self.window {
//            window.rootViewController = rootController
//        }
        UIApplication.sharedApplication().statusBarHidden = true
        //阅读信息持久化
        NSUserDefaults.standardUserDefaults().setFloat(18, forKey: "textSize")
        //小说阅读颜色样式
        //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "backgroundIndex")
        NSUserDefaults.standardUserDefaults().registerDefaults(["backgroundIndex" : 1])
        //小说阅读字体样式
        //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "textTypeIndex")
        NSUserDefaults.standardUserDefaults().registerDefaults(["textTypeIndex" : 1])
        //小说阅读白天模式or黑夜模式
        NSUserDefaults.standardUserDefaults().registerDefaults(["dayTypeIndex" : 0])        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "transitionIndex")
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "curPage")
        
        NSUserDefaults.standardUserDefaults().registerDefaults(["isFirstLaunch": true])
        NSUserDefaults.standardUserDefaults().registerDefaults(["userTitle": "个人中心"])
        NSUserDefaults.standardUserDefaults().registerDefaults(["userImage": "center_photo"])
        
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("isFirstLaunch")
        print(isFirstLaunch)
        if !isFirstLaunch {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
                    window?.makeKeyAndVisible()
            
                    storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let rootController = storyBoard?.instantiateViewControllerWithIdentifier("MainViewController")
            
                    if let window = self.window {
                        window.rootViewController = rootController
                    }
        }
        
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.makeKeyAndVisible()
//        
//        storyBoard = UIStoryboard(name: "Paper", bundle: nil)
//        let rootController = storyBoard?.instantiateViewControllerWithIdentifier("PaperMain")
//        
//        if let window = self.window {
//            window.rootViewController = rootController
//        }


        ShareSDK.registerApp("1720f399fc3e4", activePlatforms: [
                SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeQQ.rawValue,
                SSDKPlatformType.TypeWechat.rawValue
            ], onImport: { (platformType) in
                switch platformType {
                case SSDKPlatformType.TypeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
            }) { (platformType, appInfo) in
                switch platformType {
                case SSDKPlatformType.TypeSinaWeibo:
                    appInfo.SSDKSetupSinaWeiboByAppKey("4037468528", appSecret: "f2688540de16a6dc814144a692b2ba8e", redirectUri: "https://www.baidu.com", authType: SSDKAuthTypeBoth)
                case SSDKPlatformType.TypeQQ:
                    appInfo.SSDKSetupQQByAppId("1105647136", appKey: "DMzffCKxQPx2E7Qz", authType: SSDKAuthTypeBoth)
                case SSDKPlatformType.TypeWechat:
                    appInfo.SSDKSetupWeChatByAppId("wx5dea74c0f35cc310", appSecret: "d2480b63c45f475b1de6e00b4f5dc9f0")
                default:
                    break
                }
        }
        
    
//        UITabBar.appearance().tintColor = UIColor(patternImage: UIImage(named: "shujia_heighLight")!)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

