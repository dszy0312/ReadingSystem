//
//  JournalSequenceCollectionViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["DetailCell","TitleCell","HeaderView"]

class JournalSequenceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(JournalSequenceDetailCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier[0])
//        self.collectionView?.registerClass(JournalSequenceTitleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier[1])
//        self.collectionView?.registerClass(JournalSequenceHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier[2])

        

        // Do any additional setup after loading the view.
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
        return 2
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! JournalSequenceDetailCollectionViewCell
            cell.numberButton.setTitle("\(indexPath.row)", forState: .Normal)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! JournalSequenceTitleCollectionViewCell
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: JournalSequenceHeaderCollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[2], forIndexPath: indexPath) as! JournalSequenceHeaderCollectionReusableView
            switch indexPath.section {
            case 0:
                headerView!.titleLabel.text = "飙升排行"
            case 1:
                headerView!.titleLabel.text = "测试排行"
            default:
                break
            }
        }
        
        return headerView!
    }

    
    //MARK:UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.row {
        case 0:
            return CGSize(width: self.view.bounds.width, height: 150)
        default:
            return CGSize(width: self.view.bounds.width, height: 30)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 40)
    }
    
    

    
    
    

}
