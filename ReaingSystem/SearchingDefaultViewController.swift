//
//  SearchingDefaultViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SearchingDefaultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    //跳转查询结果页面标示
    var searchResultSegue = "ShowSearchingSegue"
    
    var transitionDelegate = SearchingTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchbar.delegate = self
        searchbar.becomeFirstResponder()
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        searchbar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == searchResultSegue {
            let toVC = segue.destinationViewController as! SearchingListViewController
            toVC.transitioningDelegate = transitioningDelegate
            toVC.modalPresentationStyle = .Custom
            searchbar.resignFirstResponder()
        
        }
    }

    
    
    //MARK: collectionView DataSource Delegate FlowLayout
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 7
        case 1:
            return 6
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0,1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath) as! SearchingHistoryCollectionViewCell
            cell.nameLabel.text = "都市青春"
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! SearchingDefaultListCollectionViewCell
            cell.bookNameLabel.text = "魔戒"
            cell.bookAuthorLabel.text = "刘绍江"
            cell.bookIntroduceLabel.text = "今天是个好日子，挑本书看吧！"
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! SearchingHeaderCollectionReusableView
        
        switch indexPath.section {
        case 0:
            headerView.backgroundColor = UIColor.whiteColor()
            headerView.titleLabel.text = "历史记录"
            headerView.clearLabel.text = "清除"
        case 1:
            headerView.backgroundColor = UIColor.whiteColor()
            headerView.titleLabel.text = "热搜词"
            headerView.clearLabel.text = "换一换"
        case 2:
            headerView.backgroundColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
            headerView.titleLabel.text = "热搜榜"
            headerView.clearLabel.alpha = 0
            headerView.clearButton.alpha = 0
        default:
            break
        }
        
        return headerView
    }
    
    //flowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section {
        case 0,1:
            return CGSize(width: self.collectionView.bounds.width / 3, height: 50)
        case 2:
            return CGSize(width: self.collectionView.bounds.width, height: 130)
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    //MARK: searchbar delegate 
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSegueWithIdentifier(searchResultSegue, sender: self)
    }
    



}
