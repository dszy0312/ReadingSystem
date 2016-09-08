//
//  ListenViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet var tabItems: [UIButton]!
    
    @IBOutlet weak var containerView: UIView!
    //选中标记
    var numberArray = [false,true,true,true]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func changeItem(sender: UIButton) {
        switch sender.tag {
        case 0:
            if numberArray[0] {
                defaultChange()
                numberArray[0] = false
                backgroundView.center = sender.center
                
            }
        case 1:
            if numberArray[1] {
                defaultChange()
                numberArray[1] = false
                backgroundView.center = sender.center
            }
        case 2:
            if numberArray[2] {
                defaultChange()
                numberArray[2] = false
                backgroundView.center = sender.center
            }
        case 3:
            if numberArray[3] {
                defaultChange()
                numberArray[3] = false
                backgroundView.center = sender.center
            }
        default:
            break
        }
        let childVC = getTabViewController()
        childVC.changeIndex(sender.tag)
    }

    func defaultChange() {
        numberArray = numberArray.map({_ in
            true
        })
    }
    //获取子视图控制器
    func getTabViewController() -> ListenTabViewController {
        var childVC: ListenTabViewController?
        for toVC in self.childViewControllers {
            if let tab = toVC as? ListenTabViewController {
                childVC = tab
            }
        }
        
        return childVC!
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
