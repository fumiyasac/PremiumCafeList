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

class DisplayController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //カフェ検索用の検索バー
    @IBOutlet var cafeSearchBar: UISearchBar!
    
    //カフェ表示のテーブルビュー
    @IBOutlet var cafeTableView: UITableView!
    
    //Cafeデータを格納する場所
    var cafeDataArray: NSMutableArray = NSMutableArray()
    
    //テーブルビューの要素数
    let sectionCount: Int = 1
    
    //テーブルビューセルの高さ
    let tableViewFirstHeight: CGFloat = 190.0
    let tableViewSecondHeight: CGFloat = 76.0
    
    //検索文字列
    var targetString: String = ""
    
    //出現中の処理
    override func viewWillAppear(animated: Bool) {
        
        //Parseからのデータを取得してテーブルに表示する
        self.loadParseData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデリゲート
        self.cafeTableView.delegate = self
        self.cafeTableView.dataSource = self
        
        //検索バーのデリゲート
        self.cafeSearchBar.delegate = self
        self.cafeSearchBar.showsCancelButton = true
        self.cafeSearchBar.placeholder = "検索したい文字を入力"
        
        //Xibのクラスを読み込む宣言を行う
        let nibFirst:UINib = UINib(nibName: "FirstDisplayCell", bundle: nil)
        self.cafeTableView.registerNib(nibFirst, forCellReuseIdentifier: "FirstDisplayCell")

        let nibSecond:UINib = UINib(nibName: "SecondDisplayCell", bundle: nil)
        self.cafeTableView.registerNib(nibSecond, forCellReuseIdentifier: "SecondDisplayCell")
    }
    
    //検索バーの関する設定一覧
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //検索クエリの一覧を取得する
        self.targetString = searchText
        self.loadParseData()
        self.view.endEditing(true)
    }
    
    //テーブルの要素数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //取得データの総数
        if self.cafeDataArray.count > 0 {
            return self.cafeDataArray.count
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
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FirstDisplayCell") as? FirstDisplayCell
            
            //各値をセルに入れる
            let cafe : AnyObject = self.cafeDataArray.objectAtIndex(indexPath.row)

            let dispImgFile: PFFile = (cafe.valueForKey("CafeImage") as? PFFile)!
            
            dispImgFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell!.firstCafeImageView.image = image
                }
            }
            
            cell!.firstCafeName.text = cafe.valueForKey("name") as? String
            
            cell!.firstCafeCommentSum.text = String(cafe.valueForKey("commentSum")!) + "コメント"
            
            let commentAmountValue: Int = cafe.valueForKey("commentAmount") as! Int
            cell!.firstCafeCommentAmount.text = "合計" + (String(commentAmountValue) as String) + "点"
            
            cell!.firstCafePublishDate.text = cafe.valueForKey("publishDate") as? String
            
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            
            //画像のセルなので特に飾りはなし
            cell!.accessoryType = UITableViewCellAccessoryType.None
            return cell!
        
        } else {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("SecondDisplayCell") as? SecondDisplayCell
        
            //各値をセルに入れる
            let cafe : AnyObject = self.cafeDataArray.objectAtIndex(indexPath.row)
            
            let dispImgFile: PFFile = (cafe.valueForKey("CafeImage") as? PFFile)!
            
            dispImgFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell!.secondCafeImageView.image = image
                }
            }
        
            cell!.secondCafeName.text = cafe.valueForKey("name") as? String
            
            cell!.secondCafeCommentSum.text = String(cafe.valueForKey("commentSum")!) + "コメント"
            
            let commentAmountValue: Int = cafe.valueForKey("commentAmount") as! Int
            cell!.secondCafeCommentAmount.text = "合計" + (String(commentAmountValue) as String) + "点"
            
            cell!.secondCafePublishDate.text = cafe.valueForKey("publishDate") as? String
            
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            
            //セルの右に矢印をつけてあげる
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell!
        }
        
    }
    
    //セルをタップした時に呼び出される
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //セグエの実行時に値を渡す
        let cafeDetailData: AnyObject = self.cafeDataArray.objectAtIndex(indexPath.row)
        performSegueWithIdentifier("goComment", sender: cafeDetailData)
    }
    
    //セルの高さを返す ※任意
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return self.tableViewFirstHeight
        } else {
            return self.tableViewSecondHeight
        }
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //コメント表示画面へ行く前に詳細データを渡す
        if segue.identifier == "goComment" {
            let commentController = segue.destinationViewController as! CommentController
            commentController.cafeDetaillData = sender
        }
    }
    
    //ログアウトアクション
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        
        //ログアウトして戻す
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //ストックアクション
    @IBAction func stockAction(sender: UIBarButtonItem) {
        
    }
    
    //シェアアクション
    @IBAction func shareAction(sender: UIBarButtonItem) {
        
    }
    
    //データのリロード
    func loadParseData() {
        
        //いったん空っぽにしておく
        self.cafeDataArray.removeAllObjects()
        
        //parse.comのデータベースからデータを取得する
        let query:PFQuery = PFQuery(className: "CafeMaster")
        
        //whereKeyメソッドで検索条件を指定
        if !self.targetString.isEmpty {
            query.whereKey("IntroduceDetail", containsString: self.targetString)
        }
        
        //orderByAscendingでカラムに対して昇順で並べる指定
        query.orderByDescending("createdAt")
        
        //制限をかける
        query.limit = 20
        
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
                        self.cafeDataArray.addObject(object)
                    }
                    
                    //テーブルビューをリロードする
                    self.cafeTableView.reloadData()
                }
                
            } else {
                
                //異常処理の際にはエラー内容の表示
                print("Error: \(error!) \(error!.userInfo)")
            }
            //------ クロージャー内の処理：ここまで↑ -----
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
