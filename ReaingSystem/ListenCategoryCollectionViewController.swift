//
//  ListenSequenceCollectionViewController.swift
//  ReaingSystem
//  听书分类
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["CategoryCell", "HeaderView"]

class ListenCategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //分类数据
    var categoryData: ListenCategoryRoot!

    override func viewDidLoad() {
        super.viewDidLoad()

        getListenCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return categoryData != nil ? categoryData.returnData.count : 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let list = categoryData.returnData[section].children {
            return list.count
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! ListenCategoryCollectionViewCell
        cell.setData(categoryData.returnData[indexPath.section].children[indexPath.row])
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: ListenCategoryHeaderCollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! ListenCategoryHeaderCollectionReusableView
            headerView!.titleLabel.text = categoryData.returnData[indexPath.section].categoryName
        }
        
        return headerView!
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: (self.view.bounds.width - 20) / 3 , height: 30)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    //网络请求
    func getListenCategory() {
        NetworkHealper.Get.receiveJSON(URLHealper.getVoiceCategory.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.categoryData = ListenCategoryRoot(fromDictionary: dictionary!)
            self.collectionView?.reloadData()
            
        }
        
        
    }



}
