//
//  InterestViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  兴趣选择视图控制器
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //兴趣标题是否选中
    var selected = false
    //选中兴趣标题存储
    private var interestChosedSet: Set<String> = []

    //兴趣列表数据
    var rows: [Row]?
    
    //详情页转场标示
    private let segueIdentifier = "DetailSegue"
    //自定义转场代理
    var transitionDelegate = DisappearTransitionDelegate()
    
    //开始按钮
    @IBOutlet weak var startButton: UIButton!
    //collection列表
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        //网络请求兴趣列表
        getInterests()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //转场准备
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let newVC = segue.destinationViewController as! PersonalCenterViewController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
        }
    }
    
    //输出选中兴趣标题
    @IBAction func startAction(sender: UIButton) {
        
        for i in interestChosedSet {
            print(i)
        }
        
    }
    
    @IBAction func begainReadingClick(sender: UIButton) {
        guard interestChosedSet != [] else {
            return
        }
        
        sendResult(interestChosedSet)
        
    }
    //返回上一级
    @IBAction func backAction(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! InterestCollectionViewCell
        if rows != nil {
            if rows?.count == 12 {
                cell.imageView.image = rows![indexPath.row].imageData
                cell.nameLabel.text = rows![indexPath.row].categoryName
                cell.nameID = rows![indexPath.row].categoryID
            } else {
                if indexPath.row <= rows!.count - 1 {
                    cell.imageView.image = rows![indexPath.row].imageData
                    cell.nameLabel.text = rows![indexPath.row].categoryName
                    cell.nameID = rows![indexPath.row].categoryID
                } else {
                    cell.imageView.image = UIImage(named: "leading_loading")
                    cell.nameLabel.text = ""
                }
            }
        } else {
            cell.imageView.image = UIImage(named: "leading_loading")
            cell.nameLabel.text = ""
        }
        
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
        return CGSize(width: self.view.frame.width / 4, height: 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestCollectionViewCell
        
        if cell.isChosed {
            cell.isChosed = false
            cell.selectedImageView.alpha = 0
            interestChosedSet.remove(cell.nameID)
        } else {
            cell.isChosed = true
            cell.selectedImageView.alpha = 1
            
            interestChosedSet.insert(cell.nameID)
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    //MARK:网络请求
    //请求兴趣标题数据
    func getInterests() {
        
        NetworkHealper.Get.receiveJSON(URLHealper.interestsURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let interests = Interests(fromDictionary: dictionary!)
            //保证数据存在
            guard interests.rows.count > 0 else {
                print("没有数据")
                return
            }
            
            self.rows = interests.rows
            self.collectionView.reloadData()
            
            //获取图片
            for i in 0..<self.rows!.count {
                let imageURL = baseURl + self.rows![i].categoryImg
                self.getImage(i, url: imageURL)
            }

            

        }
    }
    //请求兴趣标题图片
    func getImage(index: Int, url: String) {
        NetworkHealper.Get.receiveData(url) { (data, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let image = UIImage(data: data!) {
                self.rows![index].imageData = image
                self.collectionView.reloadData()
                
            } else {
                print("不是图片")
            }
        }

    }
    //发送兴趣选择结果，跳转页面
    func sendResult(interestChosedSet: Set<String>) {
        var interestChosedArray: [String] = []
        //唯一标识码
        let uuid = checkUuid()
        print(uuid)
        //兴趣选中数组
        for name in interestChosedSet {
            interestChosedArray.append(name)
        }
        
        let parameters: [String: AnyObject] = [
            "uuid": uuid!,
            "sex": 1,
            "interests": interestChosedArray
        ]
        NetworkHealper.Post.receiveJSON(URLHealper.interestsSendURL.introduce(), parameter: parameters) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isFirstLaunch")
                    self.performSegueWithIdentifier("DetailSegue", sender: self)
                } else {
                    print("发送失败")
                }
            }

        }
    }
    //UUID数据持久化，加入钥匙串
    func checkUuid() -> String?{
        // keyChain group
        var service = "com.weihui.ReaingSystem"
        // access group
        var group = ""
        // 查询name
        let kReadingUUIDKey = "UUIDKey"
        var keychain: KeychainUtility?
        // 发布者身份检查 可以实现不同APP调用
        guard let appIdPrefix = NSBundle.mainBundle().infoDictionary!["AppIdentifierPrefix"] as? String else {
            print("No AppIdPrefix")
            return nil
        }
        group = appIdPrefix + service
        keychain = KeychainUtility(service: service, group: group)
        // 查询钥匙串中是否有存储的UUID
        if let data = keychain?.query(kReadingUUIDKey) {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        } else {
            //唯一标识码
            let str = (UIDevice.currentDevice().identifierForVendor! as NSUUID).UUIDString
            //加载UUID到钥匙串
            guard let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) else {
                print("data转换失败")
                return nil
            }
            guard let result = keychain?.insert(data, key: kReadingUUIDKey) else {
                print("加载UUID失败")
                return nil
            }
            return str
        }
        
        
        
    }
    

}
