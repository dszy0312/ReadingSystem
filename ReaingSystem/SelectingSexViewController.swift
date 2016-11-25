//
//  SelectingSexViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["SexCell","HeaderView"]

class SelectingSexViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SexMoreSelectDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    //精选页传递数据
    var classifyData: SelectData!
    //男女页面基本信息
    var sexRootData: SelectSexRootData!
    //男女页面详情信息
    var sexDetailData: [String: SelectSexDetailRoot] = [:]
    
    //模拟navigation跳转
    var transitionDelegate = ReadedBookListTransitionDelegate()
    

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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.titleLabel.text = classifyData.iconName
    }
    
    @IBAction func backClick(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sexRootData != nil ? sexRootData.data2.count : 0
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! SelectingSexCollectionViewCell
        if let detailRoot = sexDetailData[sexRootData.data2[indexPath.section].categoryID] {
            if let datas = detailRoot.data {
                if datas.count < indexPath.row + 1  {
                    cell.titleLabel.text = ""
                    cell.bookImage.image = UIImage(named: "bookLoading")
                } else {
                        cell.setData(datas[indexPath.row])
                }
                
            }
        }
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: SelectingSexHeaderCollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! SelectingSexHeaderCollectionReusableView
            headerView?.setData(sexRootData.data2[indexPath.section])
            headerView?.curSection = indexPath.section
            headerView?.moreDelegate = self
        }
        
        return headerView!
    }
    
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("xuanzhong")
        guard let datas = sexDetailData[sexRootData.data2[indexPath.section].categoryID]?.data else {
            return
        }
        guard datas.count >= indexPath.row + 1 else {
            return
        }
        guard let id = datas[indexPath.row].bookID else {
            return
        }
        if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            if id != "" {
                toVC.selectedBookID = datas[indexPath.row].bookID
                self.presentViewController(toVC, animated: true, completion: {
                })
            }

        }
    
    }

    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width / 3, height: 140)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //代理方法
    func sectionSelect(section: Int) {
        if let toVC = childVC("Category", vcName: "CategoryDetail") as? CategoryDetailViewController {
            toVC.sexData = sexRootData.data2[section]
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            self.presentViewController(toVC, animated: true, completion: nil)
        }

    }

    //MARK：私有方法
    //页面跳转方法
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }

    

    //网络请求
    func getData(id: String) {
        //iconID暂时默认
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getChildCategoryListByCategory.introduce(), parameter: ["categoryID": id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.sexRootData = SelectSexRootData(fromDictionary: dictionary!)
            //self.collectionView.reloadData()
            self.getDetailData(self.sexRootData.data2)

        }
    }
    func getDetailData(data: [SelectSexData2]) {
        for i in 0..<data.count {
            NetworkHealper.GetWithParm.receiveJSON(URLHealper.getHotStoryByCategory.introduce(), parameter: ["categoryID": data[i].categoryID]) { (dictionary, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                let detailRoot = SelectSexDetailRoot(fromDictionary: dictionary!)
                self.sexDetailData[data[i].categoryID] = detailRoot
                self.collectionView.reloadData()
            }
            
        }

    }

}
