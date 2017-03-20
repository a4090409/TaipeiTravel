//
//  ＷalkthroughViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/3/2.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet var heafLabel:UILabel!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var footLabel:UILabel!
    @IBOutlet var pageControl:UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heafLabel.text = heading
        footLabel.text = content
        imageView.image =  UIImage(named: imageFile)
        heafLabel.numberOfLines = 1;
        heafLabel.adjustsFontForContentSizeCategory = true

        footLabel.numberOfLines = 1;
        footLabel.adjustsFontForContentSizeCategory = true
        pageControl.currentPage = index
        
        switch index {
        case 0...4:forwardButton.setTitle("下一步", for: .normal)
        case 5:forwardButton.setTitle("開始", for: .normal)
        default:
            break
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        switch index {
        case 0...4:
            // parent = pagecontroller
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.forward(index: index)
            
        case 5:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewd")
            dismiss(animated: true, completion: nil)
        default:
            print("nextButton2")
            break
        }
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
