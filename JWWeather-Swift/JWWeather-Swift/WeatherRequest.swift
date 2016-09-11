//
//  WeatherRequest.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation

class WeatherRequest: NSObject {
    
    var requestWeatherSuccess:((weatherData:NSData)->(Void))?
    var requestWeatherFail:(()->(Void))?
    
    
    override init() {
        super.init()
    }
    
    func requestWeather(cityName:String)  {
        let location = cityName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlStr = ("http://api.map.baidu.com/telematics/v3/weather?location=") + location + ("&output=json&ak=C3d2845360d091a5e8f42f605b7472ea")
        
        let url:NSURL = NSURL.init(string: urlStr)!
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let request = NSURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if data?.length > 0 {
                    self.requestWeatherSuccess!(weatherData:data!)
                } else {
                    self.requestWeatherFail!()
                }
            }
        }
        task.resume()

    }
}