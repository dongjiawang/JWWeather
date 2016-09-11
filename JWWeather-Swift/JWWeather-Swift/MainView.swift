//
//  MainView.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/8.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
import SnapKit

class MainView: UIView,UIScrollViewDelegate {
    
    var BGScroll: UIScrollView!
    var BGImageView: UIImageView!
    var refreshLabel:UILabel!
    var cityName: UILabel!
    var weatherView:TodayView!
    var otherWeatherView:OtherDayView!
    var blurView:UIImageView!
    
    
    
    var mainViewRefreshWeather:((Void)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    func initSubViews() {
        BGImageView = UIImageView.init(frame: self.bounds)
        BGImageView.backgroundColor = UIColor.clearColor()
        BGImageView.contentMode = UIViewContentMode.ScaleAspectFill
        BGImageView.userInteractionEnabled = true
        self.addSubview(BGImageView)
        
        blurView = UIImageView.init(frame: BGImageView.bounds)
        blurView.alpha = 0
        blurView.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0)
        blurView.contentMode = UIViewContentMode.ScaleAspectFill
        BGImageView.addSubview(blurView)
        
        BGScroll = UIScrollView.init(frame: BGImageView.bounds)
        BGScroll.backgroundColor = UIColor.clearColor()
        BGScroll.showsVerticalScrollIndicator = false
        BGScroll.delegate = self
        BGScroll.contentSize = CGSizeMake(0, BGImageView.frame.height*2)
        BGImageView.addSubview(BGScroll)
        
        refreshLabel = UILabel.init(frame: CGRectMake(0, -40, self.frame.width, 40))
        refreshLabel.backgroundColor = UIColor.clearColor()
        refreshLabel.textColor = UIColor.whiteColor()
        refreshLabel.font = UIFont.systemFontOfSize(20)
        refreshLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(refreshLabel)
        
        weatherView = TodayView.init(frame: BGImageView.bounds)
        BGScroll.addSubview(weatherView)
        
        otherWeatherView = OtherDayView.init(frame: CGRectMake(0, BGImageView.frame.height + BGImageView.frame.origin.y, BGImageView.frame.width, BGImageView.frame.height))
        BGScroll.addSubview(otherWeatherView)
    }
    
    func setBGimage() {
        let tool = JWTool()
        if tool.dayTime() {
            BGImageView.image = UIImage.init(named: "BGImage-day")
        } else {
            BGImageView.image = UIImage.init(named: "BGImage-night")
        }
        
        blurView.image = tool.createBlurBackground(BGImageView.image!, blurRadius: 10.0)
    }
            
    /**
     根据数据更新UI
     
     - parameter weatherDict: 天气数据
     */
    func updateMainView(dayDataArr:NSMutableArray, weatherDetailData:NSMutableArray) {
        let mainData = dayDataArr[0] as? WeatherMainModel
        weatherView.updateMainViewWeather(mainData!)
        weatherView.updateMainViewIndexLabel(weatherDetailData)
        otherWeatherView.initSingleWeather(dayDataArr)
        
        otherWeatherView.frame = CGRectMake(0, weatherView.frame.height, otherWeatherView.frame.width, otherWeatherView.frame.height)
        BGScroll.contentSize = CGSizeMake(0, weatherView.frame.height + otherWeatherView.frame.height)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= -50) {
            refreshLabel.text = "松开刷新";
        }else{
            //防止在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
            refreshLabel.text = "下拉刷新";
        }
        
        if scrollView.contentOffset.y <= 0 {
            refreshLabel.frame = CGRectMake(0, -(scrollView.contentOffset.y + 40), refreshLabel.frame.width, refreshLabel.frame.height)
        }
        
        var scrollScale = scrollView.contentOffset.y / scrollView.frame.height
        
        if scrollScale <= 0 {
            scrollScale = 0
            return
        } else if scrollScale >= 0.9 {
            scrollScale = 0.9
            return
        }
        blurView.alpha = scrollScale
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset = scrollView.contentOffset
        if (scrollOffset.y < -50) {
            self.mainViewRefreshWeather!()
            dispatch_async(dispatch_get_main_queue()) {
                scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}