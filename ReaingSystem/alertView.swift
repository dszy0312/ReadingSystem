//
//  alertView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

func alertMessage(title: String, message: String, vc: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let cancleAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
    alertController.addAction(cancleAction)
    vc.presentViewController(alertController, animated: true, completion: nil)
}

func alertShareMessage(vc: UIViewController, completion: (SSDKPlatformType) -> Void)  {
    let alertController = UIAlertController(title: "选择分享", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    let weixinAction = UIAlertAction(title: "微信", style: UIAlertActionStyle.Default) { (_) in
        completion(.TypeWechat)
    }
    let weiboAction = UIAlertAction(title: "微博", style: UIAlertActionStyle.Default) { (_) in
        completion(.TypeSinaWeibo)
    }
    let qqAction = UIAlertAction(title: "QQ", style: UIAlertActionStyle.Default) { (_) in
        completion(.TypeQQ)
    }
    alertController.addAction(weixinAction)
    alertController.addAction(weiboAction)
    alertController.addAction(qqAction)
    vc.presentViewController(alertController, animated: true, completion: nil)
}
//id 分享内容的id, name: 标题，author: 作者，image: 图片， shartype: 分享类型（图书，音频，报纸，期刊，分别是【appappstory, appvoice, appnewspaper, appmagazine】）,from: 0表示分享的文本、1表示分享书籍或者有声小说, type: 目前是微信，微博，QQ三种
//
func alertShare(id: String, name: String, author: String, image: UIImage?, shareType: String,from: String, type: SSDKPlatformType) {
    let shareParames = NSMutableDictionary()
    shareParames.SSDKSetupShareParamsByText("\n\(author)", images:image, url: NSURL(string: "\(baseURl)ShareContent/index.html?id=\(id)&shareType=\(shareType)&type=\(from)"), title: name, type: SSDKContentType.WebPage)
    shareParames.SSDKSetupSinaWeiboShareParamsByText("\(name)\(baseURl)ShareContent/index.html?id=\(id)&shareType=\(shareType)&type=\(from)", title: author, image: image, url: NSURL(string: "\(baseURl)ShareContent/index.html?id=\(id)&shareType=\(shareType)&type=\(from)"), latitude: 0, longitude: 0, objectID: nil, type: SSDKContentType.Auto)
    ShareSDK.share(type, parameters: shareParames) { (states, nil, entity, error) in
        switch states {
        case SSDKResponseState.Success: print("分享成功")
        case SSDKResponseState.Fail: print("失败： \(error)")
        case SSDKResponseState.Cancel: print("取消")
        default:
            break
        }
    }
}
//报纸分享
func alertShare2(id: String, detail: String, title: String, sectionID: String, image: UIImage?, type: SSDKPlatformType, baseURL: String) {
    let shareParames = NSMutableDictionary()
    shareParames.SSDKSetupShareParamsByText("\n\(detail)", images:image, url: NSURL(string: "\(baseURL)\(sectionID)?aid=\(id)"), title: title, type: SSDKContentType.WebPage)
    shareParames.SSDKSetupSinaWeiboShareParamsByText("\(title)\(baseURL)\(sectionID)?aid=\(id)", title: title, image: image, url: NSURL(string: "\(baseURL)\(sectionID)?aid=\(id)"), latitude: 0, longitude: 0, objectID: nil, type: SSDKContentType.Auto)
    ShareSDK.share(type, parameters: shareParames) { (states, nil, entity, error) in
        switch states {
        case SSDKResponseState.Success: print("分享成功")
        case SSDKResponseState.Fail: print("失败： \(error)")
        case SSDKResponseState.Cancel: print("取消")
        default:
            break
        }
    }
}
