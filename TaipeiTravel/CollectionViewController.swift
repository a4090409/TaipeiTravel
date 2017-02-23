//
//  CollectionViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/20.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var fullScreenSize :CGSize!
    var arrData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //資料
        for i in 1...4 {
            arrData.append("\(i)")
        }
        //每個cell的大小
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 設置委任對象
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 加入畫面中
        //self.view.addSubview(collectionView)
    }

    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "Cell", for: indexPath as IndexPath)
                    as! MyCollectionViewCell
            
           
            cell.imageView.image = #imageLiteral(resourceName: "Green-Taipei-101-3")
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
