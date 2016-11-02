//
//  JournalSelectViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["SelectCell"]

class JournalSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //网络数据
    var datas: [JournalClassifyData2] = []
    //选中值
    var selectedIndex: Int! {
        didSet {
            curIndex = selectedIndex
        }
    }
    //当前位置 (接受列表传值)
    var curIndex = 0 {
        didSet {
            switch curIndex {
            case 0:
                collectionView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            case datas.count - 1, datas.count - 2:
                collectionView.setContentOffset(CGPoint(x: CGFloat(100 * datas.count) - self.view.frame.width,y: 0), animated: true)
            default:
                collectionView.setContentOffset(CGPoint(x: 100 * (curIndex - 1), y: 0), animated: true)
            }
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //网络请求
        getListData()
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
        
        
        return datas.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! JournalSelectCollectionViewCell
        cell.nameLabel.text = datas[indexPath.row].categoryName
        cell.nameLabel.textColor = UIColor.defaultColor()
        if curIndex == indexPath.row {
            cell.nameLabel.textColor = UIColor.mainColor()
        }
        
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

        return CGSize(width: 100 , height: self.collectionView.bounds.height - 2)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        let pVC = self.parentViewController as! JournalViewController
        pVC.selectedIndex = selectedIndex
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //网络请求
    func getListData() {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getChildCategoryList.introduce(), parameter: ["categoryID":"0004"]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let dataRoot = JournalClassifyRoot(fromDictionary: dictionary!)
            self.datas = []
            self.datas.appendContentsOf(dataRoot.data2)
            let pVC = self.parentViewController as! JournalViewController
            pVC.idArray = self.datas.map({
                $0.categoryID
            })
            self.collectionView.reloadData()
            
        }
        
        
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
