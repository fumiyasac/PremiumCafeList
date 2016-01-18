//
//  AddController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2016/01/15.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//Parseのインポート
import Parse

class AddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //編集フラグ
    var editCommentFlag: Bool = false
    
    //カフェのobjectID
    var cafeMasterObjectID: String = ""
    
    //カフェのobjectIDに紐づくコメントのobjectId
    var targetObjectID: String = ""
    
    //コメント用のメンバ変数
    var cafeCommentDetail: String = ""
    var cafeCommentStarNumber: Int = 0
    var cafeCommentPFFile: PFFile!
    var cafeCommentImage: UIImage? = nil
    
    //保存用メンバ変数
    var saveTargetImage: UIImage? = nil
    var saveTargetComment: String!
    var saveTargetStar: Int = 0
    var saveTargetCafeMasterId: String!
    var uploadImageFile: PFFile!
    
    //詳細表示
    @IBOutlet var cafeCommentLabel: UILabel!
    @IBOutlet var cafeCommnetField: UITextField!
    @IBOutlet var cafeCommentStar: UISegmentedControl!
    @IBOutlet var cafeCommentImageView: UIImageView!
    
    //ゴミ箱ボタン
    @IBOutlet var deleteCommentButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITextFieldのデリゲートの設定
        self.cafeCommnetField.delegate = self
        
        //編集モード時
        if self.editCommentFlag == true {
            
            self.cafeCommentLabel.text = "コメントの編集"
            
            //前のページから渡された情報が入力された状態にする
            self.cafeCommnetField.text = self.cafeCommentDetail
            
            self.cafeCommentStar.selectedSegmentIndex = self.cafeCommentStarNumber
            self.saveTargetStar = self.cafeCommentStarNumber + 1
            
            let dispImgFile: PFFile = self.cafeCommentPFFile
            
            dispImgFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    self.cafeCommentImage = image
                    self.cafeCommentImageView.image = self.cafeCommentImage
                }
            }
            
        //追加モード時
        } else {

            self.cafeCommentLabel.text = "コメントの追加"
            self.saveTargetStar = 1
            
            //削除ボタンは押せないようにする
            self.deleteCommentButton.enabled = false
        }
        
    }

    //評価点数のセグメントコントロールを変更した時のアクション
    @IBAction func starChangeAction(sender: UISegmentedControl) {
        self.saveTargetStar = sender.selectedSegmentIndex + 1
    }
    
    //大もとのViewをタップした時のアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    //戻るボタンのアクション
    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //カメラボタンのアクション
    @IBAction func cameraButtonAction(sender: UIBarButtonItem) {
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "Cafeで「食べたもの」の写真",
            message: "食べたものや外観を記録しよう！",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "ライブラリから選択",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "カメラで撮影",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.Cancel,
                handler: handlerActionSheet
            )
        )
        presentViewController(alertActionSheet, animated: true, completion: nil)
        
    }
    
    //アクションシートの結果に応じて処理を変更
    func handlerActionSheet(ac: UIAlertAction) -> Void {
        
        switch ac.title! {
            
        case "ライブラリから選択":
            self.selectAndDisplayFromPhotoLibrary()
            break
        case "カメラで撮影":
            self.loadAndDisplayFromCamera()
            break
        case "キャンセル":
            break
        default:
            break
        }
        
    }
    
    //ライブラリから写真を選択してimageに書き出す
    func selectAndDisplayFromPhotoLibrary() {
        
        //フォトアルバムを表示
        let ipc = UIImagePickerController()
        ipc.allowsEditing = true
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    //カメラで撮影してimageに書き出す
    func loadAndDisplayFromCamera() {
        
        //カメラを起動
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        ip.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(ip, animated: true, completion: nil)
    }
    
    //画像を選択した時のイベント
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //画像をセットして戻る
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //リサイズして表示する
        let resizedImage = CGRectMake(
            image.size.width / 4.0,
            image.size.height / 4.0,
            image.size.width / 2.0,
            image.size.height / 2.0
        )
        
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, resizedImage)
        self.cafeCommentImageView.image = UIImage(CGImage: cgImage!)
    }
    
    //追加ボタンのアクション
    @IBAction func addCommentAction(sender: UIBarButtonItem) {
        
        //UIImageデータを取得する
        self.saveTargetImage = self.cafeCommentImageView.image
        
        //バリデーションを通す前の準備
        self.saveTargetComment = self.cafeCommnetField.text
        
        //Error:UIAlertControllerでエラーメッセージ表示
        if (self.saveTargetImage == nil || self.saveTargetComment.isEmpty) {
        
            //エラーのアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "エラー",
                message: "入力必須の項目に不備があります。",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
            
        } else {
            
            let imageData: NSData = UIImagePNGRepresentation(self.saveTargetImage!)!
            self.uploadImageFile = PFFile(name: "cafe_comment.png", data: imageData)!
            
            //編集モード時
            if self.editCommentFlag == true {
                
                //コメントのIDと対応する対象のデータを更新
                let query = PFQuery(className: "CafeTransactionComment")
                query.getObjectInBackgroundWithId(self.targetObjectID, block: { object, error in
                    
                    object?["CafeMasterObjectId"] = self.cafeMasterObjectID
                    object?["CafeCommentDetail"] = self.saveTargetComment
                    object?["CafeCommentStar"] = self.saveTargetStar
                    object?["CafeCommentImage"] = self.uploadImageFile
                    object?["commentUsername"] = PFUser.currentUser()!.username!
                    
                    object?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        
                        //Debug.
                        //print("Object id: \(self.targetObjectID) has been updateed.")
                        
                        if success {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    }
                })
                
            //追加モード時
            } else {
                
                //追加対象のデータを投入
                let targetObject = PFObject(className: "CafeTransactionComment")
                
                //追加対象のデータを投入
                targetObject["CafeMasterObjectId"] = self.cafeMasterObjectID
                targetObject["CafeCommentDetail"] = self.saveTargetComment
                targetObject["CafeCommentStar"] = self.saveTargetStar
                targetObject["CafeCommentImage"] = self.uploadImageFile
                targetObject["commentUsername"] = PFUser.currentUser()!.username!
                
                //追加処理
                targetObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    
                    //Debug.
                    //print("New Object has been added.")
                    
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                
            }
            
        }
    }
    
    //削除ボタンのアクション
    @IBAction func deleteCommentAction(sender: UIBarButtonItem) {
        
        //コメントのIDと対応するデータを削除
        let query = PFQuery(className: "CafeTransactionComment")
        query.getObjectInBackgroundWithId(self.targetObjectID, block: { object, error in
            
            if error == nil {
                object?.deleteInBackground()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
