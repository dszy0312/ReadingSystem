//
//  CategoryViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ImageCell","TitleCell","HeaderView", "DetailSegue"]

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    //分类页面数据
    var categoryData: CategoryRoot!
    //标题数据
    var sectionData: [CategoryRow] = []
    //数据格式化
    var formatData: [String : [CategoryRow]] = [:]
    
    // 选中数据
    var selectedData: CategoryRow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getNetworkData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[3] {
            let toVC = segue.destinationViewController as! CategoryDetailViewController
            toVC.selectedData = self.selectedData
        }
    }
    //个人中心
    @IBAction func personalShowClick(sender: UIButton) {
        
        if let pVC = self.parentViewController?.parentViewController as? PersonalCenterViewController {
            if pVC.showing == false {
                pVC.showing = true
            } else {
                pVC.showing = false
            }
        }
    }

    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let id = sectionData[section].categoryID
        
        return formatData[id] != nil ? formatData[id]!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0,1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! CategoryImageCollectionViewCell
            cell.setData(formatData[sectionData[indexPath.section].categoryID]![indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! CategoryTitleCollectionViewCell
            cell.setData(formatData[sectionData[indexPath.section].categoryID]![indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier[2], forIndexPath: indexPath) as! CategoryHeaderCollectionReusableView
        headView.sectionNameLabel.text = sectionData[indexPath.section].categoryName
        return headView
    }
    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.row {
        case 0,1:
            return CGSize(width: self.view.frame.width / 2, height: 180)
        default:
            return CGSize(width: self.view.frame.width / 2, height: 50)
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedData = formatData[sectionData[indexPath.section].categoryID]![indexPath.row]
        self.performSegueWithIdentifier(reuseIdentifier[3], sender: self)
    }

    
    //网络请求
    func getNetworkData() {
        NetworkHealper.Get.receiveJSON(URLHealper.getCategory.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.categoryData = CategoryRoot(fromDictionary: dictionary!)
            if let datas = self.categoryData.rows {
                self.formatData(datas)
            }
            self.collectionView?.reloadData()
            
        }
    }
    
    //数据格式化
    func formatData(datas: [CategoryRow]) {
        var array = datas
        //获取标题数组
        print("总数\(array.count)")
        for i in 0..<array.count {
            print("\(i)")
            if array[i].isTopCategory == 1 {
                self.sectionData.append(array[i])
            }
        }
        //获取Cell字典
        for j in self.sectionData {
            self.formatData[j.categoryID] = []
            for i in datas {
                if i.categoryID.hasPrefix(j.categoryID) && i.categoryID != j.categoryID {
                    self.formatData[j.categoryID]?.append(i)
                }
            }
        }
        
    }

    
    

}
