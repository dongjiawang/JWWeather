//
//  OtherDayView.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
import SnapKit


class OtherDayView: UIView {
    var tipLabel:UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tipLabel = UILabel.init()
        tipLabel.backgroundColor = UIColor.clearColor()
        tipLabel.text = "未来三天天气"
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(22)
        tipLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(tipLabel)
        tipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(40)
            make.width.equalTo(frame.width)
            make.height.equalTo(40)
        }
    }
    
    func initSingleWeather(weatherArr:NSMutableArray) {
        var singleViewTop:CGFloat = 60
        for index in 0...weatherArr.count - 2 {
            let weatherSingleView = weatherView.init(frame: CGRectMake(0, singleViewTop, self.frame.width, 180))
            self.addSubview(weatherSingleView)
            let weatherModel = weatherArr[index + 1] as! WeatherMainModel
            weatherSingleView.initSubLabels(weatherModel)
            
            singleViewTop = CGFloat(180*(index + 1)) + 80
        }
    
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.width, singleViewTop+20)
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class weatherView: UIView {
    
    var dateLabel = UILabel()
    var weatherIcon = UIImageView()
    var weatherLabel = UILabel()
    var windLabel = UILabel()
    var temperatureLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubLabels(weatherModel:WeatherMainModel) {
        dateLabel.backgroundColor = UIColor.clearColor()
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.systemFontOfSize(24)
        dateLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(dateLabel)
        dateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(self.frame.width)
            make.height.equalTo(40)
        }

        
        weatherIcon.backgroundColor = UIColor.clearColor()
        weatherIcon.contentMode = UIViewContentMode.ScaleToFill
        weatherIcon.alpha = 0.8
        self.addSubview(weatherIcon)
        weatherIcon.snp_makeConstraints { (make) in            
            make.centerX.equalTo(self.snp_centerX).offset(-52)
            make.width.equalTo(84)
            make.height.equalTo(60)
        }
        
        weatherLabel.backgroundColor = UIColor.clearColor()
        weatherLabel.textColor = UIColor.whiteColor()
        weatherLabel.font = UIFont.systemFontOfSize(16)
        weatherLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(weatherLabel)
        weatherLabel.snp_makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp_bottom).offset(10)
            make.left.equalTo(weatherIcon.snp_right).offset(20)
            make.right.equalTo(dateLabel.snp_right)
            make.height.equalTo(40)
        }
        
        windLabel.backgroundColor = UIColor.clearColor()
        windLabel.textColor = UIColor.whiteColor()
        windLabel.textAlignment = NSTextAlignment.Left
        windLabel.font = UIFont.systemFontOfSize(16)
        self.addSubview(windLabel)
        windLabel.snp_makeConstraints { (make) in
            make.top.equalTo(weatherLabel.snp_bottom)
            make.left.equalTo(weatherLabel.snp_left)
            make.right.equalTo(weatherLabel.snp_right)
            make.height.equalTo(40)
        }
        
        weatherIcon.snp_updateConstraints { (make) in
            make.centerY.equalTo(windLabel.snp_centerY)
        }
        
        temperatureLabel.backgroundColor = UIColor.clearColor()
        temperatureLabel.textColor = UIColor.whiteColor()
        temperatureLabel.font = UIFont.systemFontOfSize(16)
        temperatureLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(temperatureLabel)
        temperatureLabel.snp_makeConstraints { (make) in
            make.top.equalTo(windLabel.snp_bottom)
            make.left.equalTo(windLabel.snp_left)
            make.right.equalTo(windLabel.snp_right)
            make.height.equalTo(40)
        }
        
        //给控件赋值
        dateLabel.text = weatherModel.date
        weatherLabel.text = weatherModel.weather
        windLabel.text = weatherModel.wind
        temperatureLabel.text = weatherModel.temperature
        weatherIcon.sd_setImageWithURL(NSURL.init(string: weatherModel.dayPictureUrl!))
    }
}
