//
//  SecondDisplayCell.swift
//  parse_spa
//
//  Created by 酒井文也 on 2016/01/01.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SecondDisplayCell: UITableViewCell {

    //UI部品のOutlet接続
    @IBOutlet var secondCafeImageView: UIImageView!
    @IBOutlet var secondCafeName: UILabel!
    @IBOutlet var secondCafePublishDate: UILabel!
    @IBOutlet var secondCafeCommentAmount: UILabel!
    @IBOutlet var secondCafeCommentSum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
