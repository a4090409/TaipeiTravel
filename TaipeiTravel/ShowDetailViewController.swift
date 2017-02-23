//
//  ShowDetailViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/14.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit
import SDWebImage

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var travelInfo:TravalInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TextView.text! = travelInfo.xbody
        TextView.backgroundColor = #colorLiteral(red: 0.9338893294, green: 0.8801650405, blue: 0.9759065509, alpha: 1)
        TextView.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        imageView.sd_setImage(with: URL(string: "https://" + travelInfo.imgfile[1])!
        )

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
