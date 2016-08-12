//
//  CustomTabBar.swift
//  CustomTabbar
//
//  Created by 魏辉 on 16/7/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol ChangeTabBarDelegate {
    func changeIndex(index: Int)
}

class CustomTabBar: UIView {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var itemBackgroundImage: UIImageView!
    
    @IBOutlet weak var itemBackgroundView1: UIView!
    @IBOutlet weak var itemBackgroundView2: UIView!
    @IBOutlet weak var itemBackgroundView3: UIView!
    @IBOutlet weak var itemBackgroundView4: UIView!
    @IBOutlet weak var itemBackgroundView5: UIView!
    
    
    
    @IBOutlet weak var itemButton1: UIButton!
    @IBOutlet weak var itemButton2: UIButton!
    @IBOutlet weak var itemButton3: UIButton!
    @IBOutlet weak var itemButton4: UIButton!
    @IBOutlet weak var itemButton5: UIButton!
    
    var delegate: ChangeTabBarDelegate?
    var numberArray = [false, true, true, true, true]
    
    
    
    
    @IBAction func changeTabBar(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if numberArray[0] {
                defaultChange()
                numberArray[0] = false
                
                selectionChange(itemButton1, imageName: "shujia_heighLight", isSelected: true)
                
                itemBackgroundImage.center = itemBackgroundView1.center
            }
            break
        case 1:
            if numberArray[1] {
                defaultChange()
                numberArray[1] = false
                selectionChange(itemButton2, imageName: "jingxuan_highLight", isSelected: true)
                
                itemBackgroundImage.center = itemBackgroundView2.center
            }
            break
        case 2:
            if numberArray[2] {
                defaultChange()
                numberArray[2] = false
                selectionChange(itemButton3, imageName: "fenlei_highLight", isSelected: true)
                
                itemBackgroundImage.center = itemBackgroundView3.center
            }
            break
        case 3:
            if numberArray[3] {
                defaultChange()
                numberArray[3] = false
                selectionChange(itemButton4, imageName: "baokan_highlight", isSelected: true)

                itemBackgroundImage.center = itemBackgroundView4.center
            }
            break
        case 4:
            if numberArray[4] {
                defaultChange()
                numberArray[4] = false
                selectionChange(itemButton5, imageName: "faxian_highlight", isSelected: true)

                itemBackgroundImage.center = itemBackgroundView5.center
            }
            break
            
            
        default:
            break
        }
        
        delegate?.changeIndex(sender.tag)
    }
    
    func defaultChange() {
        numberArray = [true, true, true, true, true]
        
        selectionChange(itemButton1, imageName: "shujia_normal",isSelected: false)
        selectionChange(itemButton2, imageName: "jingxuan_normal",isSelected: false)
        selectionChange(itemButton3, imageName: "fenlei_normal",isSelected: false)
        selectionChange(itemButton4, imageName: "baokan_normal",isSelected: false)
        selectionChange(itemButton5, imageName: "faxian_normal",isSelected: false)
        
    }
    
    func selectionChange(button: UIButton, imageName: String, isSelected: Bool) {
        button.selected = isSelected
//        button.imageView?.image = UIImage(named: imageName)
        button.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
    }
    
//    func setSelectItem(index: Int) {
//        numberArray[index] = false
//        switch index {
//        case 0:
//            self.itemButton1.selected = true
//            itemBackgroundImage.center = itemButton1.center
//        case 1:
//            self.itemButton2.selected = true
//            itemBackgroundImage.center = itemButton2.center
//        case 2:
//            self.itemButton3.selected = true
//            itemBackgroundImage.center = itemButton3.center
//        case 3:
//            self.itemButton4.selected = true
//            itemBackgroundImage.center = itemButton4.center
//        case 4:
//            self.itemButton5.selected = true
//            itemBackgroundImage.center = itemButton5.center
//            
//        default:
//            break
//        }
//    }

    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
