//
//  WeatherRequest.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class WeatherRequest: NSObject {
    
    var requestWeatherSuccess:((_ weatherData:NSData)->(Void))?
    var requestWeatherFail:(()->(Void))?
    
    
    override init() {
        super.init()
    }
    
    func requestWeather(_ cityName:String)  {
        let location = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = ("http://api.map.baidu.com/telematics/v3/weather?location=") + location + ("&output=json&ak=C3d2845360d091a5e8f42f605b7472ea")
        
        let url:URL = URL.init(string: urlStr)!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if data?.count > 0 {
                    self.requestWeatherSuccess!(data! as NSData)
                } else {
                    self.requestWeatherFail!()
                }
            }
        }) 
        task.resume()

    }
}
