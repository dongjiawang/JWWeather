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
    var refreshImage:UIImageView!
    var cityName: UILabel!
    var weatherView:TodayView!
    var otherWeatherView:OtherDayView!
    var blurView:UIImageView!
    var animationing:Bool = false
    
    
    var mainViewRefreshWeather:((Void)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    func initSubViews() {
        BGImageView = UIImageView.init(frame: self.bounds)
        BGImageView.backgroundColor = UIColor.clear
        BGImageView.contentMode = UIViewContentMode.scaleAspectFill
        BGImageView.isUserInteractionEnabled = true
        self.addSubview(BGImageView)
        
        blurView = UIImageView.init(frame: BGImageView.bounds)
        blurView.alpha = 0
        blurView.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0)
        blurView.contentMode = UIViewContentMode.scaleAspectFill
        BGImageView.addSubview(blurView)
        
        BGScroll = UIScrollView.init(frame: BGImageView.bounds)
        BGScroll.backgroundColor = UIColor.clear
        BGScroll.showsVerticalScrollIndicator = false
        BGScroll.delegate = self
        BGScroll.contentSize = CGSize(width: 0, height: BGImageView.frame.height*2)
        BGImageView.addSubview(BGScroll)
        
        refreshLabel = UILabel()
        refreshLabel.backgroundColor = UIColor.clear
        refreshLabel.textColor = UIColor.white
        refreshLabel.font = UIFont.systemFont(ofSize: 20)
        refreshLabel.textAlignment = NSTextAlignment.center
        self.addSubview(refreshLabel)
        refreshLabel.snp.makeConstraints { (make) in
            make.top.equalTo(-40)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
        
        refreshImage = UIImageView()
        refreshImage.backgroundColor = UIColor.clear
        refreshImage.image = UIImage.init(named: "refreshImage")
        self.addSubview(refreshImage)
        refreshImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(refreshLabel.snp.centerY)
            make.right.equalTo(refreshLabel.snp.left)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        weatherView = TodayView.init(frame: BGImageView.bounds)
        BGScroll.addSubview(weatherView)
        
        otherWeatherView = OtherDayView.init(frame: CGRect(x: 0, y: BGImageView.frame.height + BGImageView.frame.origin.y, width: BGImageView.frame.width, height: BGImageView.frame.height))
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
    func updateMainView(_ dayDataArr:NSMutableArray, weatherDetailData:NSMutableArray) {
        let mainData = dayDataArr.firstObject as? WeatherMainModel
        weatherView.updateMainViewWeather(mainData!)
        weatherView.updateMainViewIndexLabel(weatherDetailData)
        otherWeatherView.initSingleWeather(dayDataArr)
        
        otherWeatherView.frame = CGRect(x: 0, y: weatherView.frame.height, width: otherWeatherView.frame.width, height: otherWeatherView.frame.height)
        BGScroll.contentSize = CGSize(width: 0, height: weatherView.frame.height + otherWeatherView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentOffset.y <= -50) {
            refreshLabel.text = "松开刷新";
        }else{
            //防止在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
            refreshLabel.text = "下拉刷新";
        }
        
        if scrollView.contentOffset.y < 0 {
            refreshLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(-(scrollView.contentOffset.y + 40))
            })
            if !animationing {
             self.startAnimation()
            }
        } else {
            refreshImage.layer.removeAnimation(forKey: "rotationAnimation")
            animationing = false
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
    
    func startAnimation() {
        animationing = true
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: Float(M_PI * 2.0) as Float)
        rotationAnimation.duration = 0.5
        rotationAnimation.repeatCount = 1000
        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        refreshImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset = scrollView.contentOffset
        if (scrollOffset.y < -50) {
            self.mainViewRefreshWeather!()
            DispatchQueue.main.async {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
