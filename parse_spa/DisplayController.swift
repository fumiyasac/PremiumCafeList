//
//  DisplayController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2015/12/28.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//Parseのインポート
import Parse

class DisplayController: UIViewController {

    var testData: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Debug.
        let displayTestData = self.testData.objectForKey("testData") as! String
        print("Current User Info：\(PFUser.currentUser())")
        print("Confirm Test Data：\(displayTestData)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
