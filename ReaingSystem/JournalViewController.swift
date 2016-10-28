//
//  JournalViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet weak var selectContainerView: UIView!
    
    @IBOutlet weak var showContainerView: UIView!

    //选中分类 （由分类选择框传值）
    var selectedIndex: Int! {
        didSet {
            let listVC = getChildListVC()
            listVC.selectedIndex = selectedIndex
        }
    }
    //分类ID数组
    var idArray: [String]! {
        didSet {
            let listVC = getChildListVC()
            listVC.idArray = idArray
        }
    }
    //当前分类下表  （由列表传值）
    var curIndex: Int! {
        didSet {
            let selectVC = getChildSelectVC()
            selectVC.curIndex = curIndex
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClick(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func defaultChange() {

    }
    //获取列表子视图控制器
    func getChildListVC() -> JournalShowPageViewController{
        var childVC: JournalShowPageViewController!
        for VC in self.childViewControllers {
            if let toVC = VC as? JournalShowPageViewController {
                childVC = toVC
            }
        }
        return childVC
    }
    //获取分类框子视图控制器
    func getChildSelectVC() -> JournalSelectViewController{
        var childVC: JournalSelectViewController!
        for VC in self.childViewControllers {
            if let toVC = VC as? JournalSelectViewController {
                childVC = toVC
            }
        }
        return childVC
    }

    


}
