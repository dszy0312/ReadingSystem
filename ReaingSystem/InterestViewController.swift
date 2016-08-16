//
//  InterestViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  兴趣选择视图控制器
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //性别选择 true：男，false：女
    var sex = true
    //兴趣标题是否选中
    var selected = false
    //选中兴趣标题存储
    private var nameArray: Set<String> = []
    //测试数据
    var testArray = ["这","是","一","个","测","式","只","是","为","了","凑","字"]
    
    //详情页转场标示
    private let segueIdentifier = "DetailSegue"
    //自定义转场代理
    var transitionDelegate = DisappearTransitionDelegate()
    
    //开始按钮
    @IBOutlet weak var startButton: UIButton!
    //性别按钮
    @IBOutlet weak var sexButton: UIButton!
    //collection列表
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //根据性别修改背景颜色
        if sex {
            sexButton.setBackgroundImage(UIImage(named: "leading_男"), forState: .Normal)
        } else {
            sexButton.setBackgroundImage(UIImage(named: "leading_女"), forState: .Normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //专场准备
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let newVC = segue.destinationViewController as! UITabBarController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
        }
    }
    
    //输出选中兴趣标题
    @IBAction func startAction(sender: UIButton) {
        
        for i in nameArray {
            print(i)
        }
        
    }
    
    //返回上一级
    @IBAction func backAction(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! InterestCollectionViewCell
        cell.nameLabel.text = testArray[indexPath.row]
        
        return cell
    }
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 4, height: 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestCollectionViewCell
        
        
        if cell.isChosed {
            cell.isChosed = false
            cell.selectedImageView.alpha = 0
            nameArray.remove(cell.nameLabel.text!)
        } else {
            cell.isChosed = true
            cell.selectedImageView.alpha = 1
            
            nameArray.insert(cell.nameLabel.text!)
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    


    
//
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
