//
//  ViewController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2015/12/16.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//Parseのインポート
import Parse

//ParseUIのインポート
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    //※ 下準備の一覧
    //1. Asset内にテキストファイル入れておく
    //2. UITextFieldはSelectable・Editableのチェックをはずし、Linksのチェックを入れる
    //3. parse_spa_material内の画像をAssets.xcassetsへ追加する
    //4. UIImageViewにcafe_cake.pngを追加し、ModeはAspectFillを選択する
    
    //UITextViewに表示する内容を格納するメンバ変数
    var guidanceText: String!
    
    //IBOutletでの接続パーツ
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var guideTextView: UITextView!
    @IBOutlet weak var goDisplayButton: UIButton!
    
    //Viewが出現したタイミングに行われる処理
    override func viewWillAppear(animated: Bool) {
        
        //ログインしていない場合
        if PFUser.currentUser() == nil {
            
            //非ログイン時の表記を設定
            self.guidanceText = LoginText.notLoginContract()
            self.goDisplayButton.setTitle("会員登録orログイン", forState: .Normal)
        
        //ログインをしている場合
        } else {

            //ログイン時の表記を設定
            self.guidanceText = LoginText.alreadyLoginContract(PFUser.currentUser()!.username!)
            self.goDisplayButton.setTitle("アプリをはじめる", forState: .Normal)
        }
        
        //テキストファイルをhtmlへコンバートする
        do {
            //正常処理
            let htmlText: String = self.guidanceText
            let encodedData = htmlText.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String : AnyObject] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.guideTextView.attributedText = attributedString
        } catch {
            //例外処理
            fatalError("テキストの変換に失敗しました")
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //UITextViewの初期位置を戻す
        guideTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    //会員登録または次の画面に遷移するアクション
    @IBAction func goNextOperationAction(sender: UIButton) {
        
        //ログインしていない場合
        if PFUser.currentUser() == nil {
            
            //ParseUIのログイン機能を呼び出す
            self.loginParseUiContents()
        
        //ログインをしている場合
        } else {
            
            //次の画面へ遷移する
            self.displayAppliContents()
        }
        
    }
    
    //次の画面へ遷移する実装を行う
    func displayAppliContents() {
        
        //セグエの実行時に値を渡す
        performSegueWithIdentifier("goDisplay", sender: nil)
    }
        
    //ParseUIのログイン機能を呼び出す実装を行う
    func loginParseUiContents() {
        
        //※UIをカスタマイズするのは面倒臭いときはこれを活用するのも一つの手かも...
        
        //Login画面に表示する要素をカスタマイズする（ParseUI.frameworkで提供されているものを継承したクラスを使用）
        let login = LoginViewController()
        login.delegate = self
        
        //ログイン画面のフィールド設定
        login.fields = (
            [
                PFLogInFields.UsernameAndPassword, //ユーザー名とパスワードのフィールド
                PFLogInFields.LogInButton,         //ログイン処理ボタン
                PFLogInFields.SignUpButton,        //サインアップ画面遷移ボタン
                PFLogInFields.PasswordForgotten,   //パスワードリマインダー
                PFLogInFields.DismissButton        //戻るボタン
            ]
        )
        
        //SignUp画面に表示する要素をカスタマイズする（ParseUI.frameworkで提供されているものを継承したクラスを使用）
        let signup = SignUpViewController()
        signup.delegate = self
        
        //サインアップ画面のフィールド設定
        signup.fields = (
            [
                PFSignUpFields.UsernameAndPassword, //ユーザー名とパスワード
                PFSignUpFields.SignUpButton,        //サインアップ処理ボタン
                PFSignUpFields.Email,               //Eメールのフィールド
                PFSignUpFields.DismissButton        //戻るボタン
            ]
        )
        
        //ログイン画面のサインアップ画面にフィールドを追加する
        login.signUpController = signup
        
        self.presentViewController(login, animated: true, completion: nil)
    }
    
    /**
     * PFLogInViewControllerDelegateのメソッド
     *
     * ※ ParseUIの機能を利用する
     */
     
    //logInViewController: ログイン処理
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        //ユーザ名とパスワードのチェック（実際はもう少し厳密にすること）
        if !username.isEmpty && !password.isEmpty {
            return true
        } else {
            
            //エラー時にはポップアップを表示する
            let alertController = UIAlertController(title: "ログインできません",
                message: "ユーザー名またはパスワードが空です。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            logInController.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
    }

    //logInViewController: ログイン処理成功時
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //logInViewController: ログイン処理失敗時
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
        //Debug.
        print("Failed to Login Action...")
    }
    
    //logInViewController: ログイン処理キャンセル時
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
        //Debug.
        print("Cancel to Login Action...")
    }
    
    /**
     * PFSignUpViewControllerDelegateのメソッド
     *
     * ※ ParseUIの機能を利用する
     */
    
    //signUpViewController: サインアップ処理
    func signUpViewController(signUpController: PFSignUpViewController,
        shouldBeginSignUp info: [String : String]) -> Bool {
        
        //初回パスワードに関するバリデーション
        if info != [:] {
           
            //サインアップに必要な情報
            let username = info["username"]
            let password = info["password"]
            let email = info["email"]
            
            //ユーザー名は3文字以上でお願いします
            if username!.utf16.count < 3 {
                
                //エラー時にはポップアップを表示する
                let alertController = UIAlertController(title: "会員登録できません",
                    message: "ユーザー名は3文字以上でお願いします。", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                signUpController.presentViewController(alertController, animated: true, completion: nil)
                return false
            
            
            //パスワードは8文字以上でお願いします
            } else if password!.utf16.count < 8 {
                
                //エラー時にはポップアップを表示する
                let alertController = UIAlertController(title: "会員登録できません",
                    message: "パスワードは8文字以上でお願いします。", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                signUpController.presentViewController(alertController, animated: true, completion: nil)
                return false
                
            //Eメールの形式チェック
            } else if isValidEmail(email!) == false {
                
                //エラー時にはポップアップを表示する
                let alertController = UIAlertController(title: "会員登録できません",
                    message: "正しいEメール形式を入力して下さい。", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                signUpController.presentViewController(alertController, animated: true, completion: nil)
                return false
                
            //正常処理
            } else {
                return true
            }

        } else {
            return false
        }

    }
    
    //signUpViewController: サインアップ処理成功時
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //signUpViewController: サインアップ処理失敗時
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        //Debug.
        print("Failed to SignUp Action...")
    }
    
    //signUpViewController: サインアップ処理キャンセル時
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        
        //Debug.
        print("Cancel to SignUp Action...")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Eメールのバリデーションチェック
    private func isValidEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(string)
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

