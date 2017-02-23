//
//  ViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/8.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseDatabase

class ViewController: UIViewController,UIViewControllerTransitioningDelegate {

    
    var urlString:String!
    var dataArray = [AnyObject]()
    var travelInfo:TravalInfo!
    
    var randomNum:UInt32!
    var usedNum = [UInt32]()
    var imgsArr:[String] = []
    var busy:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView!
    
    var ref:FIRDatabaseReference!
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    var nowday:String!
    
    var dataArrayTaipei:[JSON]!
    let customPresentAnimationController = CustomPresentAnimationController()
    override func viewDidLoad() {
        
        let now = NSDate()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        nowday = dformatter.string(from: (now as Date))
        
        ref = FIRDatabase.database().reference()

        //初始化物件
        travelInfo = TravalInfo()
        
        //呼叫DataTaipei Api
        urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5"

        let centerx = self.view.frame.width/2
        let centery = self.view.frame.height/2

        if self.busy == nil{
            self.busy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.busy.center = CGPoint(x:  centerx  , y: centery)
            self.view.addSubview(self.busy)
            
            self.busy.hidesWhenStopped = true
            self.busy.startAnimating()
        }

        // ref.child("321").childByAutoId().setValue("3345678")

        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
           
            let existsUser = snapshot.childSnapshot(forPath: "\(self.uuid!)").exists()
            
            //已存在User檢查當日是否更新
            if(existsUser)
            {
                if let NowDate = snapshot.childSnapshot(forPath: "\(self.uuid!)/nowday").value
                {
                    //當日未更新
                    if (self.nowday! != NowDate as! String)
                    {
                        //先清除使用過的推薦景點
                      self.ref.child(self.uuid!).child("usedNum").setValue([])
                        self.AlamofireStar(SetTravalInfo: true)

                    }
                    //使用已更新過內容設定travaInfo
                    else
                    {
                        self.AlamofireStar(SetTravalInfo: false)
                        self.usedNum = snapshot.childSnapshot(forPath: "\(self.uuid!)/usedNum").value as! [UInt32]
                        //self.AlamofireStar()

                        //print("now = (SetTravalInfoBysnapshot)")
                        self.SetTravalInfoBysnapshot(Snapshot: snapshot)
                    }
                }
            }
            else
            {
                //print("now = (AlamofireStar)")
                //開始讀取api資料
                self.AlamofireStar(SetTravalInfo: true)
                               //資料下載完成後
            }
            /*for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                 //print(rest.key)
                //有值檢查是否為今日最新
                if(rest.key == self.uuid)
                {
                   print(rest.value!)
                }
           }*/
         })
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        
    }
    
    
    //Api回傳設定值
    func SetTravalInfo(Json dataArrayTaipei:[JSON] )
    {
        self.travelInfo.stitle  = dataArrayTaipei[Int(self.randomNum)]["stitle"].stringValue
        self.travelInfo.cate  = dataArrayTaipei[Int(self.randomNum)]["CAT2"].stringValue
        self.travelInfo.address  = dataArrayTaipei[Int(self.randomNum)]["address"].stringValue
        self.travelInfo.imgfile  =  self.imgsArr
        self.travelInfo.MRT  = dataArrayTaipei[Int(self.randomNum)]["MRT"].stringValue
        self.travelInfo.xbody  = dataArrayTaipei[Int(self.randomNum)]["xbody"].stringValue
        self.travelInfo.MEMO_TIME  = dataArrayTaipei[Int(self.randomNum)]["MEMO_TIME"].stringValue
        self.travelInfo.trafficinfo  = dataArrayTaipei[Int(self.randomNum)]["info"].stringValue
    }
    
    func SetTravalInfoBysnapshot(Snapshot snapshot:FIRDataSnapshot)
    {
        self.travelInfo.stitle = snapshot.childSnapshot(forPath: "\(self.uuid!)/stitle").value as! String
        self.travelInfo.cate = snapshot.childSnapshot(forPath: "\(self.uuid!)/cate").value as! String
        self.travelInfo.address = snapshot.childSnapshot(forPath: "\(self.uuid!)/address").value as! String
        self.travelInfo.imgfile = snapshot.childSnapshot(forPath: "\(self.uuid!)/imgfile").value as! [String]
                self.travelInfo.MRT = snapshot.childSnapshot(forPath: "\(self.uuid!)/MRT").value as! String
        self.travelInfo.xbody = snapshot.childSnapshot(forPath: "\(self.uuid!)/xbody").value as! String
        self.travelInfo.MEMO_TIME = snapshot.childSnapshot(forPath: "\(self.uuid!)/MEMO_TIME").value as! String
        self.travelInfo.trafficinfo = snapshot.childSnapshot(forPath: "\(self.uuid!)/trafficinfo").value as! String
        self.ref.child(self.uuid!).child("nowday").setValue(self.nowday)
    }
    func  UpdateFireBase()
    {
        self.ref.child(self.uuid!).child("stitle").setValue(self.travelInfo.stitle)
        self.ref.child(self.uuid!).child("cate").setValue(self.travelInfo.cate)
        self.ref.child(self.uuid!).child("address").setValue(self.travelInfo.address)
        self.ref.child(self.uuid!).child("imgfile").setValue(self.travelInfo.imgfile)
        self.ref.child(self.uuid!).child("MRT").setValue(self.travelInfo.MRT)
        self.ref.child(self.uuid!).child("xbody").setValue(self.travelInfo.xbody)
        self.ref.child(self.uuid!).child("MEMO_TIME").setValue(self.travelInfo.MEMO_TIME)
        self.ref.child(self.uuid!).child("trafficinfo").setValue(self.travelInfo.trafficinfo)
        self.ref.child(self.uuid!).child("nowday").setValue(self.nowday)
    self.ref.child(self.uuid!).child("usedNum").setValue( self.usedNum)
       
    }
    
    func  ShowTravelInfo()
    {
        self.performSegue(withIdentifier: "ShowTravelInfo", sender: self)
    }
    func ResetTravalInfo()
    {
        repeat
        {
            self.randomNum  = arc4random_uniform(UInt32(dataArrayTaipei.count - 1))
        }while self.usedNum.contains(self.randomNum)
        
        
        self.usedNum.append(self.randomNum)
        
        self.imgsArr = self.dataArrayTaipei[Int(self.randomNum)]["file"].stringValue.components(separatedBy: "http://")
        
        SetTravalInfo(Json:  self.dataArrayTaipei)
        UpdateFireBase()
        
        self.performSegue(withIdentifier: "ShowTravelInfo", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTravelInfo"
        {
            let destination = segue.destination as! TravelDetailViewController
            destination.transitioningDelegate = self
            
            destination.travelinfo = travelInfo
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }

    func AlamofireStar(SetTravalInfo settravalInfo:Bool)
    {
        Alamofire.request(self.urlString, headers: nil).responseJSON(completionHandler: {response in
            if let sSON = response.result.value
            {
                //JSON資料處理
                let swiftyJsonVar = JSON(sSON)
                
                 self.dataArrayTaipei = swiftyJsonVar["result"]["results"].arrayValue
                
                //  let datadd = swiftyJsonVar["result"]["results"].arrayObject as! [AnyObject]
                //新北投
                //print( (dataArrayTaipei[0]["stitle"] as? String)!)
                
                repeat
                {
                    self.randomNum  = arc4random_uniform(UInt32(self.dataArrayTaipei.count - 1))
                }while self.usedNum.contains(self.randomNum)
                
                
                self.usedNum.append(self.randomNum)
                
                self.imgsArr = self.dataArrayTaipei[Int(self.randomNum)]["file"].stringValue.components(separatedBy: "http://")
                
                //print(dataArrayTaipei[0]["stitle"].stringValue)
                
                
                //print(swiftyJsonVar["result"]["results"][0]["MRT"])
                //for anyobject in swiftyJsonVar["result"]["results"].array!
                //{
                //self.anu = anyobject as AnyObject!
                //print(anyobject["MRT"])
                // self.dataArray = anyobject.arrayObject as! [AnyObject]
                //}
                
                if(settravalInfo){
                self.SetTravalInfo(Json: self.dataArrayTaipei)
                
                self.UpdateFireBase()
                }

                
                //資料完成後  出現推薦button
                let loginRegisterButton:UIButton =
                    {
                        let button = UIButton(type: .system)
                        
                        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                        button.setTitle("今日推薦景點", for: .normal)
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.setTitleColor(.white, for: .normal)
                        button.addTarget(self, action:#selector(self.ShowTravelInfo), for: .touchUpInside)
                        button.layer.cornerRadius = 15.0
                        return button
                }()
                let AgainButton:UIButton =
                    {
                        let button = UIButton(type: .system)
                        
                        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                        button.setTitle("重新推薦景點！！", for: .normal)
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.setTitleColor(.white, for: .normal)
                        button.addTarget(self, action:#selector(self.ResetTravalInfo), for: .touchUpInside)
                        button.layer.cornerRadius = 15.0
                        return button
                }()
                
                
                
                loginRegisterButton.frame = CGRect(x: self.view.frame.origin.x/2, y: self.view.frame.origin.y/3, width: self.view.frame.size.width/5, height: self.view.frame.size.height/10)
                self.view.addSubview(loginRegisterButton)
                
                
                AgainButton.frame = CGRect(x: self.view.frame.origin.x/2, y: self.view.frame.origin.y/3, width: self.view.frame.size.width/5, height: self.view.frame.size.height/10)
                self.view.addSubview(AgainButton)
                
                
                let leftConstraint = NSLayoutConstraint(
                    item: loginRegisterButton,
                    attribute: NSLayoutAttribute.leading,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.leading,
                    multiplier: 1.0,
                    constant: 100
                )
                self.view.addConstraint(leftConstraint)
                let rightConstraint = NSLayoutConstraint(
                    item: loginRegisterButton,
                    attribute: NSLayoutAttribute.trailing,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.trailing,
                    multiplier: 1.0,
                    constant: -100
                )
                self.view.addConstraint(rightConstraint)
                
                let bottomConstraint = NSLayoutConstraint(
                    item: loginRegisterButton,
                    attribute: NSLayoutAttribute.bottom,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.bottom,
                    multiplier: 1.0,
                    constant: -100
                )
                
                self.view.addConstraint(bottomConstraint)
                
                
                let againbuttonleftConstraint = NSLayoutConstraint(
                    item: AgainButton,
                    attribute: NSLayoutAttribute.leading,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.leading,
                    multiplier: 1.0,
                    constant: 100
                )
                self.view.addConstraint(againbuttonleftConstraint)
                let againbuttonrightConstraint = NSLayoutConstraint(
                    item: AgainButton,
                    attribute: NSLayoutAttribute.trailing,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.trailing,
                    multiplier: 1.0,
                    constant: -100
                )
                self.view.addConstraint(againbuttonrightConstraint)
                
                let againbuttonbottomConstraint = NSLayoutConstraint(
                    item: AgainButton,
                    attribute: NSLayoutAttribute.bottom,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.bottom,
                    multiplier: 1.0,
                    constant: -50
                )                
                self.view.addConstraint(againbuttonbottomConstraint)
                self.busy.stopAnimating()
            }
        })
    }
    //let blurEffect = UIBlurEffect(style:UIBlurEffectStyle.regular)
    //let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //blurEffectView.frame = view.bounds
    //  imageView.addSubview(blurEffectView)
}

