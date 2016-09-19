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
        tipLabel.backgroundColor = UIColor.clear
        tipLabel.text = "未来三天天气"
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 22)
        tipLabel.textAlignment = NSTextAlignment.center
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.width.equalTo(frame.width)
            make.height.equalTo(40)
        }
    }
    
    func initSingleWeather(_ weatherArr:NSMutableArray) {
        var singleViewTop:CGFloat = 80
        for index in 0...weatherArr.count - 2 {
            let weatherSingleView = weatherView.init(frame: CGRect(x: 0, y: singleViewTop, width: self.frame.width, height: 180))
            self.addSubview(weatherSingleView)
            let weatherModel = weatherArr[index + 1] as! WeatherMainModel
            weatherSingleView.initSubLabels(weatherModel)
            
            singleViewTop = CGFloat(180*(index + 1)) + 80
        }
    
        self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.width, height: singleViewTop+20)
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
    
    func initSubLabels(_ weatherModel:WeatherMainModel) {
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 24)
        dateLabel.textAlignment = NSTextAlignment.center
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.frame.width)
            make.height.equalTo(40)
        }

        
        weatherIcon.backgroundColor = UIColor.clear
        weatherIcon.contentMode = UIViewContentMode.scaleToFill
        weatherIcon.alpha = 0.8
        self.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(50)
            make.centerX.equalTo(self.snp.centerX).offset(-52)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        
        weatherLabel.backgroundColor = UIColor.clear
        weatherLabel.textColor = UIColor.white
        weatherLabel.font = UIFont.systemFont(ofSize: 16)
        weatherLabel.textAlignment = NSTextAlignment.left
        self.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.equalTo(weatherIcon.snp.right).offset(20)
            make.right.equalTo(dateLabel.snp.right)
            make.height.equalTo(40)
        }
        
        windLabel.backgroundColor = UIColor.clear
        windLabel.textColor = UIColor.white
        windLabel.textAlignment = NSTextAlignment.left
        windLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(windLabel)
        windLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherLabel.snp.bottom)
            make.left.equalTo(weatherLabel.snp.left)
            make.right.equalTo(weatherLabel.snp.right)
            make.height.equalTo(40)
        }
        
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.textAlignment = NSTextAlignment.left
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windLabel.snp.bottom)
            make.left.equalTo(windLabel.snp.left)
            make.right.equalTo(windLabel.snp.right)
            make.height.equalTo(40)
        }
        
        //给控件赋值
        dateLabel.text = weatherModel.date
        weatherLabel.text = weatherModel.weather
        windLabel.text = weatherModel.wind
        temperatureLabel.text = weatherModel.temperature
        weatherIcon.sd_setImage(with: URL.init(string: weatherModel.dayPictureUrl!))
    }
}
