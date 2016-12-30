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
    
    @IBOutlet weak var editionSelectImageView: UIImageView!
    
    @IBOutlet weak var dateSelectImageView: UIImageView!
    //期刊数据
    var paperMainRow: [PaperMainData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    //期刊日期数据
    var paperDateRow: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    //当前期刊日期
    var currentDate: String = "" 
    //当前版面
    var currentEdition: String = ""
    //显示的是日期数据还是期刊版面数据   true=版面  false=日期
    var isShowEdition = true {
        didSet {
            if isShowEdition == true {
                editionSelectImageView.alpha = 1
                dateSelectImageView.alpha = 0
            } else {
                editionSelectImageView.alpha = 0
                dateSelectImageView.alpha = 1
            }
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        editionSelectImageView.alpha = 1
        dateSelectImageView.alpha = 0
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
        if isShowEdition == true {
            return paperMainRow.count
        } else {
            return paperDateRow.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! PaperEditionCollectionViewCell
        if isShowEdition == true {
            cell.nameLabel.text = paperMainRow[indexPath.row].newspaperImgTitle
            if cell.nameLabel.text == self.currentEdition {
                cell.nameLabel.textColor = UIColor.mainColor()
            } else {
                cell.nameLabel.textColor = UIColor.blackColor()
            }
        } else {
            cell.nameLabel.text = paperDateRow[indexPath.row]
            if cell.nameLabel.text == self.currentDate {
                cell.nameLabel.textColor = UIColor.mainColor()
            } else {
                cell.nameLabel.textColor = UIColor.blackColor()
            }
        }
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
        if isShowEdition == true {
            switch paperMainRow.count {
            case 4:
                return CGSize(width: self.collectionView.frame.width - 2, height: 35)
            case 8:
                return CGSize(width: (self.collectionView.frame.width - 1) / 2, height: 35)
            case 16:
                return CGSize(width: (self.collectionView.frame.width - 3) / 4, height: 35)
            default:
                return CGSize(width: self.collectionView.frame.width - 2, height: 35)
            }
        } else {
            return CGSize(width: (self.collectionView.frame.width - 1) / 2, height: 35)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let pVC = self.parentViewController as? PaperMainViewController {
            if isShowEdition == true {
                pVC.selectedIndex = indexPath.row
            } else {
                pVC.selectedDateIndex = indexPath.row
            }
        }
    }


}
