//
//  AdviceViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/12/6.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AdviceViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var selectSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var numberLabel: UILabel!
    //最大字符数
    var kMaxtext = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.text = "请描述一下您的问题"
        textView.textColor = UIColor.lightGrayColor()
        numberLabel.text = "\(kMaxtext)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downClick(sender: UIButton) {
        let text = textView.text
        guard text != "" else {
            alertMessage("提示", message: "意见不能为空", vc: self)
            return
        }
        let type = selectSegmentControl.selectedSegmentIndex
        self.sendAdvice(text, type: type)
        textView.resignFirstResponder()
        
    }
    
    @IBAction func cancelClick(sender: UIButton) {
        textView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请描述一下您的问题"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    func textViewDidChange(textView: UITextView) {
        let text = textView.text
        let lang = textView.textInputMode?.primaryLanguage
        if lang == "zh-Hans" { //简体中文输入
            //获取高亮部分
            let range = textView.markedTextRange
            if range == nil {
                if text.length > kMaxtext {
                    let rangeIndex = (text as NSString).rangeOfComposedCharacterSequenceAtIndex(kMaxtext)
                    if rangeIndex.length == 1 {
                        textView.text = (text as NSString).substringToIndex(kMaxtext)
                    } else {
                        let rangeRange = (text as! NSString).rangeOfComposedCharacterSequencesForRange(NSMakeRange(0, kMaxtext))
                        textView.text = (text as NSString).substringWithRange(rangeRange)
                    }
                }
                numberLabel.text = "\(kMaxtext - textView.text.length)"
            }
        } else {
            if text.length > kMaxtext {
                let rangeIndex = (text as NSString).rangeOfComposedCharacterSequenceAtIndex(kMaxtext)
                if rangeIndex.length == 1 {
                    textView.text = (text as NSString).substringToIndex(kMaxtext)
                } else {
                    let rangeRange = (text as NSString).rangeOfComposedCharacterSequencesForRange(NSMakeRange(0, kMaxtext - 1))
                    textView.text = (text as NSString).substringWithRange(rangeRange)
                }
            }
            numberLabel.text = "\(kMaxtext - textView.text.length)"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if range.length < 200 {
            print(textView.text)
            return true
        } else {
            return false
        }
    }

    //意见发送到后台
    func sendAdvice(text: String, type: Int) {
        NetworkHealper.PostWithURL.receiveJSON(URLHealper.feedback.introduce(), parameter: ["Content": text, "Type": type]) { (dictionary, error) in
            guard error == nil else {
                alertMessage("提示", message: "服务器错误，请重试！", vc: self)
                return
            }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    alertMessage("提示", message: "提交出错，请重新尝试！", vc: self)
                }
            }
        }
    }

}
