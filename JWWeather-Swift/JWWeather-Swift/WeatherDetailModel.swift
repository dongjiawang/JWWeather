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
    var des:String?
    
    override init() {
        super.init()
    }
    
    func evaluationModel(weatherDic:NSDictionary) {
        tipt = weatherDic["tipt"] as? String
        des = weatherDic["des"] as? String

    }
}
