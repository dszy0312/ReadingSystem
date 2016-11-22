//
//  ListenFamousViewController.swift
//  ReaingSystem
//  听书名家
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["FamousCell", "HeaderView", "DetailSegue", "MoreSegue", "ImagesSegue"]

class ListenFamousViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FamousHeaderDelegate, ImagesShowDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //名人数据
    var famousData: ListenFamousRoot!
    //选中的名人
    var selectedAuthorID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getListenFamous()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[2] {
            let toVC = segue.destinationViewController as! ListenFamousDetailViewController
            toVC.authorID = selectedAuthorID
            
        } else if segue.identifier == reuseIdentifier[4] {
            let toVC = segue.destinationViewController as! ListenImagePageViewController
            toVC.customDelegate = self
        }
    }
    
    //MARK: collectionView delegate dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return famousData != nil ? famousData.rows.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! ListenFamousCollectionViewCell
        cell.setData(famousData.rows[indexPath.row])
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: ListenFamousHeaderCollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! ListenFamousHeaderCollectionReusableView
            headerView!.delegate = self
            headerView!.titleLabel.text = "主播秀场"
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
        return CGSize(width: self.view.bounds.width / 3 , height: 130)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedAuthorID = self.famousData.rows[indexPath.row].authorID
        self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)
    }

    
    //MARK: 代理请求 
    //FamousHeaderDelegate
    func changeView() {
        self.performSegueWithIdentifier(reuseIdentifier[3], sender: self)
    }
    //ImagesShowDelegate
    func imagesDidLoaded(index: Int, total: Int) {
        if total == 0 {
            pageControl.numberOfPages = 1
            pageControl.currentPage = 0
        } else {
            pageControl.numberOfPages = total
            pageControl.currentPage = index
        }
    }
    //暂时无用
    func selectDataLoaded(data: SelectRootData) {
        
    }
    
    //网络请求
    func getListenFamous() {
        NetworkHealper.Get.receiveJSON(URLHealper.getVoiceTopAuthorList.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.famousData = ListenFamousRoot(fromDictionary: dictionary!)
            self.collectionView.reloadData()
            
        }
    }
}
