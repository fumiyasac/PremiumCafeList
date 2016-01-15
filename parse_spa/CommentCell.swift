//
//  CommentCell.swift
//  parse_spa
//
//  Created by 酒井文也 on 2016/01/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //UI部品のOutlet接続
    @IBOutlet var commentImageView: UIImageView!
    @IBOutlet var commentStar: UILabel!
    @IBOutlet var commentUser: UILabel!
    @IBOutlet var commentDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
