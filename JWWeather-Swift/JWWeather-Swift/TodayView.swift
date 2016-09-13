//
//  TodayView.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
import SnapKit


class TodayView: UIView {
    
    var cityName = UILabel()
    var nowWeather = UILabel()
    var weatherIcon = UIImageView()
    var temLabel = UILabel()
    var weatherLable = UILabel()
    var windLabel = UILabel()
    
    var windLabelBottom = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cityName.backgroundColor = UIColor.clearColor()
        cityName.font = UIFont.boldSystemFontOfSize(25)
        cityName.textColor = UIColor.whiteColor()
        cityName.textAlignment = NSTextAlignment.Center
        self.addSubview(cityName)
        cityName.snp_makeConstraints { (make) in
            make.top.equalTo(64)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        nowWeather.backgroundColor = UIColor.clearColor()
        nowWeather.font = UIFont.systemFontOfSize(16)
        nowWeather.textColor = UIColor.whiteColor()
        nowWeather.textAlignment = NSTextAlignment.Center
        self.addSubview(nowWeather)
        nowWeather.snp_makeConstraints { (make) in
            make.top.equalTo(cityName.snp_bottom).offset(20)
            make.centerX.equalTo(cityName.snp_centerX)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        weatherIcon.backgroundColor = UIColor.clearColor()
        weatherIcon.alpha = 0.8
        weatherIcon.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(weatherIcon)
        weatherIcon.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(nowWeather.snp_bottom).offset(40)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        
        weatherLable.backgroundColor = UIColor.clearColor()
        weatherLable.font = UIFont.systemFontOfSize(25)
        weatherLable.textColor = UIColor.whiteColor()
        weatherLable.textAlignment = NSTextAlignment.Center
        self.addSubview(weatherLable)
        weatherLable.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(weatherIcon.snp_bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        temLabel.backgroundColor = UIColor.clearColor()
        temLabel.font = UIFont.systemFontOfSize(25)
        temLabel.textColor = UIColor.whiteColor()
        temLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(temLabel)
        temLabel.snp_makeConstraints { (make) in
            make.top.equalTo(weatherLable.snp_bottom).offset(20)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        windLabel.backgroundColor = UIColor.clearColor()
        windLabel.font = UIFont.systemFontOfSize(20)
        windLabel.textColor = UIColor.whiteColor()
        windLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(windLabel)
        windLabel.snp_makeConstraints { (make) in
            make.top.equalTo(temLabel.snp_bottom).offset(20)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func updateMainViewWeather(weatherModel:WeatherMainModel) {
        self.temLabel.text = weatherModel.temperature
        self.nowWeather.text = weatherModel.date
        self.weatherLable.text = weatherModel.weather
        self.windLabel.text = weatherModel.wind
        
        var iconUrl:String?            
        let tool = JWTool()
        if tool.dayTime() {
            iconUrl = weatherModel.dayPictureUrl
        } else {
            iconUrl = weatherModel.nightPictureUrl
        }
        
        weatherIcon.sd_setImageWithURL(NSURL.init(string: iconUrl!))
    }
    
    func updateMainViewIndexLabel(indexArr:NSArray) {
        var top:CGFloat = 0
        
        for tempLabel in self.subviews {
            if tempLabel.isKindOfClass(indexLabel) {
                tempLabel.removeFromSuperview()
            }
        }
        
        for index in 0...5 {
            
            if index%2 == 0 {
                top += 30
            }
            
            let label = indexLabel()
            let weatherModel = indexArr[index] as! WeatherDetailModel
            label.text = weatherModel.tipt! + (":") + weatherModel.zs!
            self.addSubview(label)
            label.snp_makeConstraints(closure: { (make) in
                make.left.equalTo((self.frame.width/2 - 10)*CGFloat(index%2) + 20)
                make.top.equalTo(windLabel.snp_bottom).offset(top)
                make.width.equalTo(self.frame.width/2 - 20)
                make.height.equalTo(40)
            })
        }
        
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.width, windLabel.frame.origin.y + top + 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class indexLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.font = UIFont.systemFontOfSize(16)
        self.textColor = UIColor.whiteColor()
        self.textAlignment = NSTextAlignment.Left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}