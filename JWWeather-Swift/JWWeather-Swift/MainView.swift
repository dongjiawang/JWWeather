//
//  MainView.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/8.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias refreshBlock=()->Void


class MainView: UIView,UIScrollViewDelegate {
    
    var BGScroll: UIScrollView!
    var BGImageView: UIImageView!
    var cityName: UILabel!
    var nowWeather: UILabel!
    var weatherIcon: UIImageView!
    var temLabel: UILabel!
    var weatherLable: UILabel!
    var windLabel: UILabel!
    var refreshLabel:UILabel!
    
    var mainViewRefreshWeather:refreshBlock?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    func initSubViews() {
        BGImageView = UIImageView.init(frame: self.bounds)
        BGImageView.backgroundColor = UIColor.clearColor()
        BGImageView.sd_setImageWithURL(NSURL.init(string: "http://cdn.ruguoapp.com/o_1as2f46mqr4d5b96la9aqb570.gif"))
        BGImageView.contentMode = UIViewContentMode.ScaleAspectFill
        BGImageView.userInteractionEnabled = true
        self.addSubview(BGImageView)
        
        BGScroll = UIScrollView.init(frame: BGImageView.bounds)
        BGScroll.backgroundColor = UIColor.clearColor()
        BGScroll.showsVerticalScrollIndicator = false
        BGScroll.delegate = self
        BGScroll.contentSize = CGSizeMake(0, self.frame.size.height + 40)
        BGImageView.addSubview(BGScroll)
        
        refreshLabel = UILabel.init(frame: CGRectMake(0, -40, self.frame.size.width, 40))
        refreshLabel.backgroundColor = UIColor.clearColor()
        refreshLabel.textColor = UIColor.blackColor()
        refreshLabel.font = UIFont.systemFontOfSize(20)
        refreshLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(refreshLabel)
        
        cityName = UILabel.init(frame: CGRectMake(0, 0, 200, 40))
        cityName.backgroundColor = UIColor.clearColor()
        cityName.font = UIFont.boldSystemFontOfSize(25)
        cityName.textColor = UIColor.whiteColor()
        cityName.textAlignment = NSTextAlignment.Center
        BGImageView.addSubview(cityName)
        cityName.snp_makeConstraints { (make) in
            make.top.equalTo(64)
            make.centerX.equalTo(BGImageView.snp_centerX)
        }
        
        nowWeather = UILabel.init(frame: CGRectMake(0, 0, 250, 40))
        nowWeather.backgroundColor = UIColor.clearColor()
        nowWeather.font = UIFont.systemFontOfSize(16)
        nowWeather.textColor = UIColor.whiteColor()
        nowWeather.textAlignment = NSTextAlignment.Center
        BGImageView.addSubview(nowWeather)
        nowWeather.snp_makeConstraints { (make) in
            make.top.equalTo(cityName.snp_bottom).offset(20)
            make.centerX.equalTo(cityName.snp_centerX)
        }
        
        weatherIcon = UIImageView.init(frame: CGRectMake(0, 0, 84, 60))
        weatherIcon.backgroundColor = UIColor.clearColor()
        weatherIcon.alpha = 0.8
        weatherIcon.contentMode = UIViewContentMode.ScaleToFill
        weatherIcon.center = BGImageView.center
        BGImageView.addSubview(weatherIcon)
        
        temLabel = UILabel.init(frame: CGRectMake(0, 0, 200, 40))
        temLabel.backgroundColor = UIColor.clearColor()
        temLabel.font = UIFont.systemFontOfSize(25)
        temLabel.textColor = UIColor.whiteColor()
        temLabel.textAlignment = NSTextAlignment.Center
        BGImageView.addSubview(temLabel)
        temLabel.snp_makeConstraints { (make) in
            make.top.equalTo(weatherIcon.snp_bottom).offset(30)
            make.centerX.equalTo(BGImageView.snp_centerX)
        }
        
        weatherLable = UILabel.init(frame: CGRectMake(0, 0, 200, 40))
        weatherLable.backgroundColor = UIColor.clearColor()
        weatherLable.font = UIFont.systemFontOfSize(25)
        weatherLable.textColor = UIColor.whiteColor()
        weatherLable.textAlignment = NSTextAlignment.Center
        BGImageView.addSubview(weatherLable)
        weatherLable.snp_makeConstraints { (make) in
            make.centerX.equalTo(BGImageView.snp_centerX)
            make.top.equalTo(temLabel.snp_bottom).offset(20)
        }
        
        windLabel = UILabel.init(frame: CGRectMake(0, 0, 200, 40))
        windLabel.backgroundColor = UIColor.clearColor()
        windLabel.font = UIFont.systemFontOfSize(20)
        windLabel.textColor = UIColor.whiteColor()
        windLabel.textAlignment = NSTextAlignment.Center
        BGImageView.addSubview(windLabel)
        windLabel.snp_makeConstraints { (make) in
            make.top.equalTo(weatherLable.snp_bottom).offset(20)
            make.centerX.equalTo(BGImageView.snp_centerX)
        }
    }

    
    /**
     解析天气数据
     
     - parameter netData: 天气数据
     */
    func analyzingNetData(netData:NSData)  {
        let json = JSON(data: netData)
        let jsonDict:Dictionary = json.dictionary! as Dictionary
        let jsonArr = jsonDict["results"]!
        let weatherDataArr = jsonArr[0]
        let weatherDict = weatherDataArr["weather_data"]
        let weatherArr = weatherDict.array
        let dayDict = weatherArr![0]
        self.updateUIWithWeather(dayDict)
    }
    
    /**
     根据数据更新UI
     
     - parameter weatherDict: 天气数据
     */
    func updateUIWithWeather(weatherDict:JSON) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.temLabel.text = weatherDict["temperature"].string
            self.nowWeather.text = weatherDict["date"].string
            self.weatherLable.text = weatherDict["weather"].string
            self.windLabel.text = weatherDict["wind"].string
        }
        var iconUrl:String?
        if dayTime() {
            iconUrl = weatherDict["dayPictureUrl"].string
        } else {
            iconUrl = weatherDict["nightPictureUrl"].string
        }
        weatherIcon.sd_setImageWithURL(NSURL.init(string: iconUrl!))
    }
    
    /**
     是否是白天
     
     - returns:
     */
    func dayTime() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let hour = calendar.component(NSCalendarUnit.Hour, fromDate: NSDate())
        if hour >= 18 || hour <= 06 {
            return false
        } else {
            return true
        }
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= -50) {
            refreshLabel.text = "松开刷新";
        }else{
            //防止在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
            refreshLabel.text = "下拉刷新";
        }
        
        if scrollView.contentOffset.y <= 0 {
            BGImageView.frame = CGRectMake(0, -scrollView.contentOffset.y, BGImageView.frame.size.width, BGImageView.frame.size.height)
            refreshLabel.frame = CGRectMake(0, -(scrollView.contentOffset.y + 40), refreshLabel.frame.size.width, refreshLabel.frame.size.height)
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset = scrollView.contentOffset
        if (scrollOffset.y < -50) {
            self.mainViewRefreshWeather?()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}