//
//  FindViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cellIdentifyArray = ["MagazineCell","ListenCell","HeaderView"]
    var headerArray = ["热文畅读","精品小听","最新杂志"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var personalButton: UIButton!
    //小说数据
    var readData: [FindRow] = []
    //听书数据
    var listenData: [FindData] = []
    //期刊数据
    var journalData: [FindData2] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getNetworkData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setImage(personalButton)
    }
    
    //个人中心展示
    @IBAction func personalShowClick(sender: UIButton) {
        if let pVC = self.parentViewController?.parentViewController as? PersonalCenterViewController {
            if pVC.showing == false {
                pVC.showing = true
            } else {
                pVC.showing = false
            }
        }
    }
    
    
    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return readData.count
        case 1:
            return listenData.count
        case 2:
            return journalData.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifyArray[0], forIndexPath: indexPath) as! FindNewMagazineCollectionViewCell
            cell.setReadData(readData[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifyArray[1], forIndexPath: indexPath) as! FindListenCollectionViewCell
            cell.setListenData(listenData[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifyArray[0], forIndexPath: indexPath) as! FindNewMagazineCollectionViewCell
            cell.setJournalData(journalData[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdentifyArray[2], forIndexPath: indexPath) as! FindHeaderCollectionReusableView
        switch indexPath.section {
        case 0:
            headView.headerTitleLabel.text = headerArray[0]
        case 1:
            headView.headerTitleLabel.text = headerArray[1]
        case 2:
            headView.headerTitleLabel.text = headerArray[2]
        default:
            break
        }
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
        
        return CGSize(width: self.view.bounds.width / 3, height: 170)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 3:
            
            return CGSize(width: self.view.bounds.width, height: 49)
        default:
            return CGSizeZero
        }
        
        
    }
    
    //设定个人中心图片
    func setImage(button: UIButton){
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            button.setImage(UIImage(named: imageUrl!), forState: .Normal)
        } else {
            button.kf_setImageWithURL(NSURL(string: imageUrl!), forState: .Normal)
        }
    }
    
    //网络请求
    func getNetworkData() {
        NetworkHealper.Get.receiveJSON(URLHealper.getFindList.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let findRoot = FindRoot(fromDictionary: dictionary!)
            self.readData.appendContentsOf(findRoot.rows)
            self.listenData.appendContentsOf(findRoot.data)
            self.journalData.appendContentsOf(findRoot.data2)
            self.collectionView.reloadData()

        }
        
        
    }

    
    

}
