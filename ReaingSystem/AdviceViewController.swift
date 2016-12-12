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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.text = "请描述一下您的问题"
        textView.textColor = UIColor.lightGrayColor()
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
        let index = selectSegmentControl.selectedSegmentIndex
        let title = selectSegmentControl.titleForSegmentAtIndex(index)
        print(title)
        self.sendAdvice(text)
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
//        let text = textView.font
//        print(text)
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
    func sendAdvice(text: String) {
        NetworkHealper.Post.receiveJSON(URLHealper.feedback.introduce(), parameter: ["Content": text]) { (dictionary, error) in
            guard error == nil else {
                print(error)
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
