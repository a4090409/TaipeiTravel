//
//  WalkthroughPageViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/3/2.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    var pageHead = ["開始畫面","景點資訊","景點介紹","景點位置","社群分享","分享畫面"]
    var pageimage = ["起始畫面1","景點介紹","景點詳細介紹","地址資訊1","分享按鈕1","分享畫面"]
    var pageFoot = ["點選今日推薦來決定今日旅遊景點！","推薦景點的詳細資訊，滑動看更多照片！","點擊景點名字可看到景點詳細介紹","點擊地址可看在地圖中看見景點定位！","滑動點擊分享按鈕","分享給社群朋友！"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let startingViewController = viewControllAtIndex(index: 0)
        {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        
        return viewControllAtIndex(index: index)
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return viewControllAtIndex(index: index)
    }
    
    func viewControllAtIndex(index:Int)-> WalkthroughViewController?{
        if index == NSNotFound || index < 0 || index >= pageHead.count
        {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentController") as? WalkthroughViewController
        {
            pageContentViewController.heading = pageHead[index]
            pageContentViewController.content = pageFoot[index]
            pageContentViewController.imageFile = pageimage[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    func forward(index:Int)
    {
        if let nextViewController = viewControllAtIndex(index:index+1)
        {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
   /* public func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return pageHead.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentController") as? WalkthroughViewController
        {
            return pageContentViewController.index
        }
        return 0
    }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
