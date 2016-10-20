//
//  PaperTestViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["HeaderView", "CategoryCell", "DetailSegue"]

class PaperCatalogueViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //期刊数据
    var paperMainRow: [PaperMainData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //选中文章ID
    var selectID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[2] {
            let toVC = segue.destinationViewController as! PaperDetailReadViewController
            toVC.newsID = selectID
        }
    }
    

    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return paperMainRow.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return paperMainRow.count != 0 ? paperMainRow[section].hotSpaceList.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! PaperCatalogueCollectionViewCell
        cell.titleLabel.text = paperMainRow[indexPath.section].hotSpaceList[indexPath.row].npNewsName
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier[0], forIndexPath: indexPath) as! PaperCatalogueCollectionReusableView
        headView.titleLabel.text = paperMainRow[indexPath.section].newspaperImgTitle
        return headView
    }
    
    //delegate
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectID = paperMainRow[indexPath.section].hotSpaceList[indexPath.row].npNewsID
        self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width - 20, height: 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    


}
