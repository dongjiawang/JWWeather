//
//  WeatherDetailModel.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation

class WeatherDetailModel: NSObject {
    var tipt:String?
    var zs:String?
    
    override init() {
        super.init()
    }
    
    func evaluationModel(_ weatherDic:NSDictionary) {
        tipt = weatherDic["tipt"] as? String
        zs = weatherDic["zs"] as? String

    }
}
