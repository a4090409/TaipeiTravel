//
//  TravelDetailViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/12.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit
import SDWebImage


class TravelDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var TravelImage:UIImageView!
    var travelinfo:TravalInfo!
    @IBOutlet var tableview:UITableView!
    var busy:UIActivityIndicatorView!
    
    var myScrollView:UIScrollView!
    var myPageControl:UIPageControl!
    var fullSize:CGSize!
    
    var fullScreenSize :CGSize!
    var arrData = [String]()
    var image1:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //資料
        for i in 1..<travelinfo.imgfile.count {
            arrData.append("\(i)")
        }
        //每個cell的大小
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
        layout.minimumInteritemSpacing = 0
        //左右
        layout.minimumLineSpacing = 0
        
        // 設置委任對象
        collectionView.delegate = self
        collectionView.dataSource = self
    
        tableview.estimatedRowHeight = 50.0
        tableview.rowHeight = UITableViewAutomaticDimension
        
        title = travelinfo.stitle

                // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "Cell", for: indexPath as IndexPath)
                    as! TaipeiCollectionViewCell
            
            cell.imageView.sd_setImage(with: URL(string: "https://" + travelinfo.imgfile[indexPath.row+1]))
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    
    override func viewWillAppear(_ animated: Bool){
        
       
       // self.TravelImage.sd_setImage(with: URL(string: "https://" + travelinfo.imgfile)!
        // )
        
        
       //let catPicturneURL = URL(string:  "https://" + travelinfo.imgfile)!
       /* let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: catPictureURL)
        { (data, response, error) in
            // 下載
            if let e = error {
                print("Error downloading  picture: \(e)")
            }
            else
            {
                if let res = response as? HTTPURLResponse
                {
                    print("Downloaded  picture with response code \(res.statusCode)")
                    if let imageData = data
                    {
                       
                        self.TravelImage.image = UIImage(data: imageData)
                    }
                    else
                    {
                        print("Image is nil")
                    }
                }
                else
                {
                    print("Couldn't get response code")
                }
            }
        }
        downloadPicTask.resume()*/
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
        }
        else if indexPath.row == 2
        {
            self.performSegue(withIdentifier: "ShowMap", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TravelDetailTableViewCell
        
        
        switch indexPath.row
        {
        case 0 :
            cell.FieldLabel.text = "名稱"
            cell.ValueLabel.text = travelinfo.stitle
            cell.accessoryType = .disclosureIndicator

        case 1:
            cell.FieldLabel.text = "類型"
            cell.ValueLabel.text = travelinfo.cate
        case 2:
            cell.FieldLabel.text = "位置"
            cell.ValueLabel.text = travelinfo.address
            cell.accessoryType = .disclosureIndicator

        case 3:
            cell.FieldLabel.text = "MRT"
            
            if (travelinfo.MRT != "")
            {
                cell.ValueLabel.text = travelinfo.MRT + "站"
            }
            else
            {
                cell.ValueLabel.text = travelinfo.MRT
            }
        //case 4:
          //  cell.FieldLabel.text = "介紹"
            //cell.ValueLabel.text = travelinfo.xbody
            //cell.accessoryType = .disclosureIndicator
        case 4:
            cell.FieldLabel.text = "營業時間"
            cell.ValueLabel.text = travelinfo.MEMO_TIME
        case 5:
            cell.FieldLabel.text = "交通資訊"
            cell.ValueLabel.text = travelinfo.trafficinfo.replacingOccurrences(of: "&amp", with: "")
        default:
            
            cell.FieldLabel.text = ""
            cell.ValueLabel.text = ""
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let  Shareaction = UITableViewRowAction(style: .default, title: "Share", handler: {
            Void in
            let defaultText = "現在就去這裡"
            
            SDWebImageManager().downloadImage(with: URL(string: "https://" + self.travelinfo.imgfile[1]), options:SDWebImageOptions.avoidAutoSetImage, progress: nil
              , completed: { (image, error, sd, bool, url) in
                if image != nil {
                    self.image1 = image
                    
                }
            })
            let activecontroller = UIActivityViewController(activityItems: [defaultText,self.image1], applicationActivities: nil)
            self.present(activecontroller, animated: true, completion: nil)
        
        })
        return [Shareaction]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMap"
        {
            if let destation = segue.destination as? MapViewController
            {
                destation.travelInfo = travelinfo
            }
        }
        if segue.identifier == "ShowDetail"
        {
            if let destation = segue.destination as? ShowDetailViewController
            {
                destation.travelInfo = travelinfo
            }
        }
    }
}
