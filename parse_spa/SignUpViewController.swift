//
//  SignUpViewController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2015/12/29.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import Parse
import ParseUI

//Login画面のデザインを変更するためのクラス
class SignUpViewController : PFSignUpViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ロゴ文言の設定
        let newLogoText = UILabel()
        newLogoText.textColor = ColorDefinition.colorWithHexString("#333333")
        newLogoText.text = "Sign Up Premium Cafe List"
        newLogoText.font = UIFont.systemFontOfSize(CGFloat(24.0))
        self.signUpView?.logo = newLogoText
        
        //背景イメージの設定
        self.backgroundImage = UIImageView(image: UIImage(named: "cafe_interior"))
        self.backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.signUpView!.insertSubview(self.backgroundImage, atIndex: 0)
        
        //Log Inボタンの背景色の変更
        self.signUpView!.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        self.signUpView!.signUpButton?.backgroundColor = ColorDefinition.colorWithHexString("#cc9933")
        
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //ロゴ文言のサイズ設定
        self.signUpView!.logo!.sizeToFit()
        let logoFrame = self.signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(
            logoFrame.origin.x,
            self.signUpView!.usernameField!.frame.origin.y - logoFrame.height - 20,
            self.signUpView!.frame.width,
            logoFrame.height
        )
        
        //背景イメージのサイズ設定
        self.backgroundImage.frame = CGRectMake(0, 0, self.signUpView!.frame.width, self.signUpView!.frame.height)
    }
    
}
