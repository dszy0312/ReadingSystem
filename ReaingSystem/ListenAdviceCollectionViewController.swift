//
//  ListenAdviceCollectionViewController.swift
//  ReaingSystem
//  听书推荐
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["ListenCell","HeaderView"]

class ListenAdviceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //听书推荐
    var adviceData: ListenAdviceRoot!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getListenAdvice()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return adviceData != nil ? adviceData.returnData.count : 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let list = adviceData.returnData[section].prList {
            return list.count
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! ListenAdviceCollectionViewCell
        cell.setData(self.adviceData.returnData[indexPath.section].prList[indexPath.row])
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: ListenAdviceHeaderCollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! ListenAdviceHeaderCollectionReusableView
            headerView!.titleLabel.text = adviceData.returnData[indexPath.section].categoryName
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
        
        return CGSize(width: self.view.bounds.width / 3, height: 180)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //网络请求
    func getListenAdvice() {
        NetworkHealper.Get.receiveJSON(URLHealper.getVoiceTJFloorData.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.adviceData = ListenAdviceRoot(fromDictionary: dictionary!)
            self.collectionView?.reloadData()
          
        }
        
        
    }
    

}
