//
//  WeatherMainModel.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation

class WeatherMainModel: NSObject {
    var date:String?
    var dayPictureUrl:String?
    var nightPictureUrl:String?
    var weather:String?
    var wind:String?
    var temperature:String?
    var detailModel:WeatherDetailModel?
    
    
    override init() {
        super.init()
    }
    
    func evaluationModel(weatherDic:NSDictionary) {
        date = weatherDic["date"] as? String
        dayPictureUrl = weatherDic["dayPictureUrl"] as? String
        nightPictureUrl = weatherDic["nightPictureUrl"] as? String
        weather = weatherDic["weather"] as? String
        wind = weatherDic["wind"] as? String
        temperature = weatherDic["temperature"] as? String
    }
}