//
//  ViewController.swift
//  ex_tableView
//
//  Created by yoshiyuki oshige on 2014/09/12.
//  Copyright (c) 2014年 yoshiyuki oshige. All rights reserved.
//

import UIKit

class MemolistTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView: UITableView!
    var texts = NSMutableArray(array : [])
    var times = NSMutableArray(array : [])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ナビゲーションバーの右側に編集ボタンを追加.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // 編集中のセル選択を許可
        myTableView.allowsSelectionDuringEditing = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* UITableViewDataSourceプロトコル…cellの総数を返す（実装必須） */
    // 配列textsの要素数がセルの数になる
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // 各行に表示するセルを返す（実装必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //http://m-shige1979.hatenablog.com/entry/2014/09/30/080000
        // 現在日時の取得
        let now = NSDate()
        
        // フォーマットを取得しJPロケール
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        
        // セル番号でセルを取り出す
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        
        // セルに表示するテキストを設定する
        cell.textLabel?.text = texts[indexPath.row] as? String
        times.addObject(dateFormatter.stringFromDate(now))
        cell.detailTextLabel?.text = (times[indexPath.row] as! String)
        return cell
    }
    
    /*
    編集ボタンが押された際に呼び出される
    */
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // TableViewを編集可能にする
        myTableView.setEditing(editing, animated: true)
        
        // 編集中のときのみaddButtonをナビゲーションバーの左に表示する
        if editing {
            print("編集中")
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addCell:")
            self.navigationItem.setLeftBarButtonItem(addButton, animated: true)
        } else {
            print("通常モード")
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
    }
    
    
    
    //削除許可
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    
    /*
    addButtonが押された際呼び出される
    */
    func addCell(sender: AnyObject) {
        print("追加")
        
        //アラートここから
        //http://swift-studying.com/blog/swift/?p=1031
        let alert = UIAlertController(title: "タイトルの入力", message: "タイトルを入力してください", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Done", style: .Default) { (action:UIAlertAction!) -> Void in
            
            // 入力したテキスト
            let textField = alert.textFields![0]
            self.texts.addObject(textField.text!)
            
            // TableViewを再読み込み.
            self.myTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction!) -> Void in
        }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    Cellを挿入または削除しようとした際に呼び出される
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.Delete {
           print("削除")
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            texts.removeObjectAtIndex(indexPath.row)
            
            // TableViewを再読み込み.
            myTableView.reloadData()
        }
    }
}