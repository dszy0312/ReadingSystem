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
    //性别选择 true：男，false：女
    var sex = true
    //兴趣标题是否选中
    var selected = false
    //选中兴趣标题存储
    private var interestChosedSet: Set<String> = []
    //
    //网络请求设置
    var networkHealper = LeadingNetworkHealper()

    //兴趣列表数据
    var rows: [Row]?
    //兴趣列表对应图片的字典
    var images: [String: UIImage]? = [:]
    
    //详情页转场标示
    private let segueIdentifier = "DetailSegue"
    //自定义转场代理
    var transitionDelegate = DisappearTransitionDelegate()
    
    //开始按钮
    @IBOutlet weak var startButton: UIButton!
    //性别按钮
    @IBOutlet weak var sexButton: UIButton!
    //collection列表
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        //根据性别修改背景颜色
        if sex {
            sexButton.setBackgroundImage(UIImage(named: "leading_男"), forState: .Normal)
        } else {
            sexButton.setBackgroundImage(UIImage(named: "leading_女"), forState: .Normal)
        }
        
        //网络请求兴趣列表
        getInterests()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //转场准备
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let newVC = segue.destinationViewController as! UITabBarController
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
        sendResult(sex, interestChosedSet: interestChosedSet)
        
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
            cell.imageView.image = images![rows![indexPath.row].categoryName]
            cell.nameLabel.text = rows![indexPath.row].categoryName
            cell.nameID = rows![indexPath.row].categoryID
        } else {
            cell.imageView.image = UIImage(named: "标题")
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

        networkHealper.getInterestingTitle { (rows, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.rows = rows
            self.collectionView.reloadData()
            
            for row in self.rows! {
                self.images![row.categoryName] = UIImage(named: "标题")
                self.getImage(row)
            }
        }
    }
    //请求兴趣标题图片
    func getImage(row: Row) {

        let imageURL = baseURl + row.categoryImg
        
        networkHealper.getInterestsImage(imageURL) { (image, error) in
            if let image = image {
                self.images![row.categoryName] = image
            } else {
                print(error)
            }
            self.collectionView.reloadData()
        }
    }
    //发送兴趣选择结果，跳转页面
    func sendResult(sex: Bool, interestChosedSet: Set<String>) {
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
            "sex": sex == true ? 1 : 0,
            "interests": interestChosedArray
        ]
        
        networkHealper.sendInterests(parameters) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.performSegueWithIdentifier("DetailSegue", sender: self)
                } else {
                    
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
