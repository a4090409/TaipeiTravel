//
//  TravalInfo.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/10.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import Foundation

class  TravalInfo
{
    
    var stitle = ""
    var cate = ""
    var address = ""
    var imgfile:[String] = []
    var MRT = ""
    //介紹
    var xbody = ""
    //營業時間
    var MEMO_TIME = ""
    //交通資訊
    var trafficinfo = ""
    
    init(stitle: String, cate: String, address: String, imgfile: [String], MRT: String, xbody: String ,MEMO_TIME:String,trafficinfo:String) {
        self.stitle = stitle
        self.cate = cate
        self.address = address
        self.imgfile = imgfile
        self.MRT = MRT
        self.xbody = xbody
        self.MEMO_TIME = MEMO_TIME
        self.trafficinfo = trafficinfo
    }
    init()
    {
        self.stitle = ""
        self.cate = ""
        self.address = ""
        self.imgfile = [""]
        self.MRT = ""
        self.xbody = ""
        self.MEMO_TIME = ""
        self.trafficinfo = ""
    }
}
