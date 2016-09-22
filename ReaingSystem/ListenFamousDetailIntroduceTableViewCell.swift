//
//  ListenFamousDetailIntroduceTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenFamousDetailIntroduceTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var introduceTextView: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ListenFamousPersonalRow) {
        introduceTextView.text = data.authorDes
    }
    


}
