//
//  LoginViewController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2015/12/29.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import Parse
import ParseUI

//Login画面のデザインを変更するためのクラス
class LoginViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ロゴ文言の設定
        let newLogoText = UILabel()
        newLogoText.textColor = ColorDefinition.colorWithHexString("#333333")
        newLogoText.text = "Login Premium Cafe List"
        newLogoText.font = UIFont.systemFontOfSize(CGFloat(24.0))
        self.logInView?.logo = newLogoText
        
        //背景イメージの設定
        self.backgroundImage = UIImageView(image: UIImage(named: "cafe_exterior"))
        self.backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView!.insertSubview(self.backgroundImage, atIndex: 0)
        
        //Log Inボタンの背景色の変更
        self.logInView!.logInButton?.setBackgroundImage(nil, forState: .Normal)
        self.logInView!.logInButton?.backgroundColor = ColorDefinition.colorWithHexString("#cc9933")
        
        //Forgot Password?の文字色
        self.logInView!.passwordForgottenButton?.setTitleColor(ColorDefinition.colorWithHexString("#666666"), forState: .Normal)
        
        //Sign Upボタンの背景色の変更
        self.logInView!.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        self.logInView!.signUpButton?.backgroundColor = ColorDefinition.colorWithHexString("#ffae00")
        
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //ロゴ文言のサイズ設定
        self.logInView!.logo!.sizeToFit()
        let logoFrame = self.logInView!.logo!.frame
        self.logInView!.logo!.frame = CGRectMake(
            logoFrame.origin.x,
            self.logInView!.usernameField!.frame.origin.y - logoFrame.height - 20,
            self.logInView!.frame.width,
            logoFrame.height
        )
        
        //背景イメージのサイズ設定
        self.backgroundImage.frame = CGRectMake(0, 0, self.logInView!.frame.width, self.logInView!.frame.height)
    }
    
}
