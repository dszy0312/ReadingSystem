//
//  JournalDTViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ListSegue", "CatalogueSegue"]

class JournalDTViewController: UIViewController, JournalPageSelectDelegate, JournalDListDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    //期刊数据
    var detailData: JournalDetailRow! {
        didSet {
            let childVC = getChildVC()
            childVC.detailData = detailData
            titleLabel.text = detailData.isMzIDText
            subTitleLabel.text = detailData.isTitle
        }
    }
    
     //杂志当期的ID
     var id: String! {
         didSet {
            self.getNetworkData(id)
         }
    }
    //杂志唯一标示
    var mzID: String!
    //列表跳转代理协议
    var listShowTransitionDelegate = JournalDTtransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let toVC = segue.destinationViewController as! JournalDListViewController
            toVC.transitioningDelegate = listShowTransitionDelegate
            toVC.modalPresentationStyle = .Custom
            toVC.selectedDelegate = self
            toVC.mzID = mzID
        } else if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! JournalDCatalogueViewController
            toVC.detailData = self.detailData
            toVC.pageSelectDelegate = self
        }
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func listShowClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
    }
    

    @IBAction func catalogueClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
    }
    
    //代理方法
    func sendIndex(index: Int) {
        let childVC = getChildVC()
        childVC.selectedPage = index
    }
    
    func listSelected(id: String) {
        getNetworkData(id)
    }
    
    
    //获取子类视图控制器
    func getChildVC() -> JournalDetailPageViewController {
        var childVC: JournalDetailPageViewController!
        for vc in self.childViewControllers {
            if let toVC = vc as? JournalDetailPageViewController {
                childVC = toVC
            }
        }
        return childVC
    }
    
    //网络请求
    func getNetworkData(id: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalDetailIssue.introduce(), parameter: ["Is_ID": id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let root = JournalDetailRoot(fromDictionary: dictionary!)
            self.detailData = root.rows.first
        }
        
        
    }
}
