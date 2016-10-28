//
//  JournalListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ListCell"]

class JournalListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var customIndex: Int!
    //当前选中ID
    var selectedIndex: String! {
        didSet {
            getListData(selectedIndex)
        }
    }
    var id: String!
    //列表数据
    var listData: [FindData2] = []

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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return listData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! JournalListCollectionViewCell
        cell.setData(listData[indexPath.row])
        //print(paperMainRow[indexPath.section].newspaperImgTitle)
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
        
        return CGSize(width: self.collectionView.bounds.width / 3, height: 180)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

    //网络请求
    func getListData(id: String) {
        print(id)
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalList.introduce(), parameter: ["categoryID":id, "pageIndex": 1]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.listData = []
            let dataRoot = JournalListRoot(fromDictionary: dictionary!)
            self.listData.appendContentsOf(dataRoot.rows)
            self.collectionView.reloadData()
        }
        
        
    }

}
