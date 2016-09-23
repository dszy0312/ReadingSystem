//
//  SexViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit


class SexViewController: UIViewController {
    
    private var sex = true
    private let segueIdentifier = "InterestSegue"
    var selectedButton: UIButton!
    
    var transitionDelegate = LeadingTransitionDelegate()
    

    @IBOutlet weak var manImageButton: UIButton!
    @IBOutlet weak var womanImageButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sexSelectAction(sender: UIButton) {
        selectedButton = sender
        if sender.tag == 0 {
            sex = true
            
        } else {
            sex = false
        }
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            setTransitionPoint(selectedButton)
            let newVC = segue.destinationViewController as! InterestViewController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
            newVC.sex = self.sex
        }
    }
    
    
    func setTransitionPoint(selected: UIButton) {
        transitionDelegate.imageView.frame = selected.frame
        transitionDelegate.imageView.image = selected.currentBackgroundImage
        
        
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
