//
//  CategoryViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellIdentifyArray = ["ImageCell","TitleCell","HeaderView"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0,1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifyArray[0], forIndexPath: indexPath) as! CategoryImageCollectionViewCell
            cell.nameLabel.text = "测试1"
            cell.numberLabel.text = "110"
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifyArray[1], forIndexPath: indexPath) as! CategoryTitleCollectionViewCell
            cell.nameLabel.text = "测试2"
            cell.numberLabel.text = "120"
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdentifyArray[2], forIndexPath: indexPath) as! CategoryHeaderCollectionReusableView
        headView.sectionNameLabel.text = "我的网文"
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
            return CGSize(width: self.view.frame.width / 2, height: 200)
        default:
            return CGSize(width: self.view.frame.width / 2, height: 50)
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    
    

}
