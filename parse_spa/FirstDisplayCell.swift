//
//  FirstDisplayCell.swift
//  parse_spa
//
//  Created by 酒井文也 on 2016/01/01.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class FirstDisplayCell: UITableViewCell {

    //UI部品のOutlet接続
    @IBOutlet var firstCafeImageView: UIImageView!
    @IBOutlet var firstCafeName: UILabel!
    @IBOutlet var firstCafeCommentSum: UILabel!
    @IBOutlet var firstCafeCommentAmount: UILabel!
    @IBOutlet var firstCafePublishDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
