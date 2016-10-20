//
//  PaperEditionSelectViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["DateSegue", "TitleCell"]

class PaperEditionSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //期刊数据
    var paperMainRow: [PaperMainData] = [] {
        didSet {
            print("改变的时间： \(paperMainRow.count)")
            self.collectionView.reloadSections(NSIndexSet(index: 0))

        }
    }

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
    

    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return paperMainRow.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! PaperEditionCollectionViewCell
        cell.nameLabel.text = paperMainRow[indexPath.row].newspaperImgTitle
        //print(paperMainRow[indexPath.section].newspaperImgTitle)
        return cell
        
    }
    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch paperMainRow.count {
        case 4:
            print("这里运行了一下")
            return CGSize(width: self.collectionView.frame.width - 2, height: 35)
        case 8:
            return CGSize(width: (self.collectionView.frame.width - 1) / 2, height: 35)
        case 16:
            return CGSize(width: (self.collectionView.frame.width - 3) / 4, height: 35)
        default:
            return CGSize(width: self.collectionView.frame.width - 2, height: 35)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
