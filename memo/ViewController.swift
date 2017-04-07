//
//  ViewController.swift
//  memo
//
//  Created by dionysos on 2015/08/31.
//  Copyright (c) 2015年 Tomoko Takagi. All rights reserved.
//  ここから転載
//  tono-n-chi.com/blog/2015/03/ios-touch-drawing-in-swift/
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var saveImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        saveImageView.image = image
        self.view.sendSubviewToBack(saveImageView)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //UITableViewDataSource書くときに必要
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    @IBOutlet weak var canvas: UIImageView!
    @IBAction func colorselect(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            let penColor = UIColor.blackColor()
            penColor.setStroke()
        case 1:
            let penColor = UIColor.whiteColor()
            penColor.setStroke()
        default:
            let penColor = UIColor.blackColor()
            penColor.setStroke()
        }
    }
    
    @IBAction func save(sender: UIButton) {
        let alertController = UIAlertController(title: "確認", message: "メモをカメラロールに保存しますか？", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in UIImageWriteToSavedPhotosAlbum(self.canvas.image!,nil,nil,nil)
           print("pushed OK!")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in print("Pushed CANCEL!")
        }
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clear(sender: UIButton) {
        clear()
    }
    
    var pen_flg  = 0
    var penColor = UIColor.blackColor()
    var lastDrawImage: UIImage!
    var bezierPath: UIBezierPath!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチ開始時の座標を取得
        let touch = touches.first!
        let currentPoint:CGPoint = touch.locationInView(canvas)
        bezierPath = UIBezierPath()
        //ベジェの終点スタイルの指定
        // Xcode7にアップデートした際、kCGLineCapRoundについてエラーが出るのでひとまずコメントアウト
        //bezierPath.lineCapStyle = kCGLineCapRound
        //起点（movetopoint）をcurrentに指定
        bezierPath.moveToPoint(currentPoint)
    }
    
    /**
    * タッチ移動時の処理
    */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if bezierPath == nil {
            return
        }
        let touch = touches.first!
        let currentPoint:CGPoint = touch.locationInView(canvas)
        bezierPath.addLineToPoint(currentPoint)
        drawLine(bezierPath)
    }
    
    
    /**
    * タッチ終了時の処理
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチされていないときは何もしない
        if bezierPath == nil {
            return
        }
        let touch = touches.first!
        let currentPoint:CGPoint = touch.locationInView(canvas)
        bezierPath.addLineToPoint(currentPoint)
        drawLine(bezierPath)
        lastDrawImage = canvas.image
    }
    
    /**
    * 描画処理
    */
    func drawLine(path:UIBezierPath) {
        
        //ここでの描画結果は表示はされない（見えない）が、描画結果はUIImageで取得できる
        UIGraphicsBeginImageContext(canvas.frame.size)
        if lastDrawImage != nil {
            lastDrawImage.drawAtPoint(CGPointZero)
        }
        pen_select()
        penColor.setStroke()
        
        path.stroke()
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func pen_select() {
        switch pen_flg{
        case 0: //鉛筆
            bezierPath.lineWidth = 3.0
            penColor = UIColor.blackColor()
            penColor.setStroke()
        case 1: //消しゴム
            bezierPath.lineWidth = 20.0
            penColor = UIColor.whiteColor()
            penColor.setStroke()
        default:
            bezierPath.lineWidth = 3.0
            penColor = UIColor.blackColor()
            penColor.setStroke()
        }
    }
    
    func clear() {
        lastDrawImage = nil
        canvas.image = nil
        //undoStack.addObject("clear");
    }
    
    
    func synthesizeImage(names: Array<String>, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        for name in names {
            if let image = UIImage(named: name) {
                image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
            }
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
}