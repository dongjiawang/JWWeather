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
        cityName.backgroundColor = UIColor.clear
        cityName.font = UIFont.boldSystemFont(ofSize: 25)
        cityName.textColor = UIColor.white
        cityName.textAlignment = NSTextAlignment.center
        self.addSubview(cityName)
        cityName.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        nowWeather.backgroundColor = UIColor.clear
        nowWeather.font = UIFont.systemFont(ofSize: 16)
        nowWeather.textColor = UIColor.white
        nowWeather.textAlignment = NSTextAlignment.center
        self.addSubview(nowWeather)
        nowWeather.snp.makeConstraints { (make) in
            make.top.equalTo(cityName.snp.bottom).offset(20)
            make.centerX.equalTo(cityName.snp.centerX)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        weatherIcon.backgroundColor = UIColor.clear
        weatherIcon.alpha = 0.8
        weatherIcon.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(nowWeather.snp.bottom).offset(40)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        
        weatherLable.backgroundColor = UIColor.clear
        weatherLable.font = UIFont.systemFont(ofSize: 25)
        weatherLable.textColor = UIColor.white
        weatherLable.textAlignment = NSTextAlignment.center
        self.addSubview(weatherLable)
        weatherLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(weatherIcon.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        temLabel.backgroundColor = UIColor.clear
        temLabel.font = UIFont.systemFont(ofSize: 25)
        temLabel.textColor = UIColor.white
        temLabel.textAlignment = NSTextAlignment.center
        self.addSubview(temLabel)
        temLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherLable.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        windLabel.backgroundColor = UIColor.clear
        windLabel.font = UIFont.systemFont(ofSize: 20)
        windLabel.textColor = UIColor.white
        windLabel.textAlignment = NSTextAlignment.center
        self.addSubview(windLabel)
        windLabel.snp.makeConstraints { (make) in
            make.top.equalTo(temLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func updateMainViewWeather(_ weatherModel:WeatherMainModel) {
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
        
        weatherIcon.sd_setImage(with: URL.init(string: iconUrl!))
    }
    
    func updateMainViewIndexLabel(_ indexArr:NSArray) {
        var top:CGFloat = 0
        
        for tempLabel in self.subviews {
            if tempLabel.isKind(of: indexLabel.self) {
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
            label.snp.makeConstraints({ (make) in
                make.left.equalTo((self.frame.width/2 - 10)*CGFloat(index%2) + 20)
                make.top.equalTo(windLabel.snp.bottom).offset(top)
                make.width.equalTo(self.frame.width/2 - 20)
                make.height.equalTo(40)
            })
        }
        
        self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.width, height: windLabel.frame.origin.y + top + 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class indexLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
