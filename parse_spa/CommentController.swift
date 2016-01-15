//
//  CommentController.swift
//  parse_spa
//
//  Created by 酒井文也 on 2016/01/14.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//Parseのインポート
import Parse

class CommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //詳細表示
    @IBOutlet var cafeDetailTitle: UILabel!
    @IBOutlet var cafeDetailImageView: UIImageView!
    @IBOutlet var cafeDetailCatchCopy: UILabel!
    @IBOutlet var cafeDetailIntroduction: UILabel!
    
    //編集フラグ
    var editFlag: Bool = false
    
    //カフェの詳細データ
    var cafeDetaillData: AnyObject!
    
    //コメント用テーブルビュー
    @IBOutlet var cafeDetailCommentTable: UITableView!
    
    //Cafeデータを格納する場所
    var cafeCommentArray: NSMutableArray = NSMutableArray()
    
    //テーブルビューの要素数
    let sectionCount: Int = 1
    
    //出現中の処理
    override func viewDidAppear(animated: Bool) {
        
        //Parseからのデータを取得してテーブルに表示する
        self.loadParseCommentData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カフェ詳細データを表示
        let dispImgFile: PFFile = (self.cafeDetaillData.valueForKey("CafeImage") as? PFFile)!
        
        dispImgFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image = UIImage(data: imageData!)
                self.cafeDetailImageView.image = image
            }
        }
        
        self.cafeDetailTitle.text = self.cafeDetaillData.valueForKey("name") as? String
        self.cafeDetailCatchCopy.text = self.cafeDetaillData.valueForKey("catchCopy") as? String
        self.cafeDetailIntroduction.text = self.cafeDetaillData.valueForKey("IntroduceDetail") as? String
        
        //テーブルビューのデリゲート設定
        self.cafeDetailCommentTable.delegate = self
        self.cafeDetailCommentTable.dataSource = self
        
        //Xibのクラスを読み込む
        let nibDefault:UINib = UINib(nibName: "CommentCell", bundle: nil)
        self.cafeDetailCommentTable.registerNib(nibDefault, forCellReuseIdentifier: "CommentCell")
        
        //自動計算の場合は必要
        self.cafeDetailCommentTable.estimatedRowHeight = 44.0
        self.cafeDetailCommentTable.rowHeight = UITableViewAutomaticDimension
    }

    //テーブルの要素数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //取得データの総数
        if self.cafeCommentArray.count > 0 {
            return self.cafeCommentArray.count
        } else {
            return 0
        }
    }
    
    //テーブルのセクションを設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionCount
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentCell
            
        //各値をセルに入れる
        let cafe : AnyObject = self.cafeCommentArray.objectAtIndex(indexPath.row)
            
        let dispImgFile: PFFile = (cafe.valueForKey("CafeCommentImage") as? PFFile)!
            
        dispImgFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell!.commentImageView.image = image
                }
        }
            
        cell!.commentUser.text = cafe.valueForKey("commentUsername") as? String
        cell!.commentStar.text = String(cafe.valueForKey("CafeCommentStar")!)
        cell!.commentDetail.text = cafe.valueForKey("CafeCommentDetail") as? String
            
        //自分のコメントの場合だけは編集可能
        if PFUser.currentUser()!.username! == cafe.valueForKey("commentUsername") as? String {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell!
        
    }
    
    //セルをタップした時に呼び出される
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //セグエの実行時に値を渡す
        /*
        let cafeCommentData: AnyObject = self.cafeCommentArray.objectAtIndex(indexPath.row)
        if PFUser.currentUser()!.username! == cafeCommentData.valueForKey("commentUsername") as? String {
            performSegueWithIdentifier("goAddComment", sender: cafeCommentData)
        }
        */
    }
    
    //戻るボタンのアクション
    @IBAction func backAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //コメント新規追加
    @IBAction func commnetAddAction(sender: UIBarButtonItem) {
        
    }
    
    //データのリロード
    func loadParseCommentData() {
        
        //いったん空っぽにしておく
        self.cafeCommentArray.removeAllObjects()
        
        //parse.comのデータベースからデータを取得する
        let query:PFQuery = PFQuery(className: "CafeTransactionComment")
        
        //orderByAscendingでカラムに対して昇順で並べる指定
        query.orderByDescending("createdAt")
        
        //制限をかける
        query.limit = 100
        
        //クロージャーの中で上記の検索条件に該当するオブジェクトを取得する
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            
            //------ クロージャー内の処理：ここから↓ -----
            //エラーがないかの確認
            if error == nil {
                
                //データが存在する場合はNSMutableArrayへデータを格納
                if let objects = objects {
                    
                    for object in objects {
                        
                        //取得したオブジェクトをメンバ変数へ格納
                        self.cafeCommentArray.addObject(object)
                    }
                    
                    //テーブルビューをリロードする
                    self.cafeDetailCommentTable.reloadData()
                }
                
            } else {
                
                //異常処理の際にはエラー内容の表示
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        //------ クロージャー内の処理：ここまで↑ -----
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
