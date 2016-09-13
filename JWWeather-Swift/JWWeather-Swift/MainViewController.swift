//
//  ViewController.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/6.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    let locService = LoactionService()
    var requestWeather = WeatherRequest()
    var subViews:MainView?
    
    var watiHUD:MBProgressHUD?
    var alertCtrl:UIAlertController?
    var cityName:String = "北京市"
    let weatherDetailArr = NSMutableArray()
    let dayDataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        subViews = MainView.init(frame: self.view.bounds)
        
        locService.locationServiceStart()
        locService.locationStart = {
            self.showWaitHUD()
        }
        locService.locationSucess = {(city)->Void in
            self.cityName = city
            self.requestWeather.requestWeather(self.cityName)
            self.subViews?.weatherView.cityName.text = self.cityName
        }
        locService.locationFail = {
            self.hideWaitHUD()
            self.showAlertCtrl("获取地理位置失败")
        }
        
        requestWeather.requestWeatherSuccess = {(weatherData) in
            self.hideWaitHUD()
            self.analyzingNetData(weatherData)
            dispatch_async(dispatch_get_main_queue(), { 
              self.subViews?.updateMainView(self.dayDataArr, weatherDetailData: self.weatherDetailArr)  
            })
        }
        requestWeather.requestWeatherFail = {
            self.showAlertCtrl("获取天气信息失败")
            self.hideWaitHUD()
        }
        
        subViews!.mainViewRefreshWeather = {
            self.showWaitHUD()
            self.requestWeather.requestWeather(self.cityName)
        }
        self.view.addSubview(subViews!)
        
        let settingBtn = UIButton.init()
        settingBtn.backgroundColor = UIColor.blueColor()
        settingBtn .addTarget(self, action: #selector(clickedSettingBtn), forControlEvents: .TouchUpInside)
        self.view.addSubview(settingBtn)
        settingBtn.snp_makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subViews!.setBGimage()
    }
    
    func clickedSettingBtn() {
        
    }
    
    /**
     解析天气数据
     
     - parameter netData: 天气数据
     */
    func analyzingNetData(netData:NSData)  {
        
        let jsonStr = try? NSJSONSerialization
            .JSONObjectWithData(netData, options:NSJSONReadingOptions.MutableContainers)
        let resultArray = jsonStr?.objectForKey("results") as? NSArray
        let weatherDetailDic = resultArray![0] as? NSDictionary
        let indexArr = weatherDetailDic!["index"] as? NSArray
        weatherDetailArr.removeAllObjects()
        for indexDic in indexArr! {
            let indexModel = WeatherDetailModel()
            indexModel.evaluationModel(indexDic as! NSDictionary)
            weatherDetailArr.addObject(indexModel)
        }
        
        let weatherDataArr = weatherDetailDic!["weather_data"] as? NSArray
        dayDataArr.removeAllObjects()
        for weatherDic in weatherDataArr! {
            let weatherModel = WeatherMainModel()
            weatherModel.evaluationModel(weatherDic as! NSDictionary)
            dayDataArr.addObject(weatherModel)
        }
    }

    
    /**
     弹出提示信息
     
     - parameter message: 信息内容
     */
    func showAlertCtrl(message:String) {
        if (alertCtrl != nil) {
            return
        }
        alertCtrl = UIAlertController.init(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl!.addAction(UIAlertAction.init(title: "重新获取", style: UIAlertActionStyle.Default, handler: { (alert) in
            dispatch_async(dispatch_get_main_queue(), {
                self.locService.locationServiceStart()
                self.alertCtrl = nil
            })
        }))
        alertCtrl!.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertCtrl!, animated: true, completion: nil)
    }
    
    func showWaitHUD() {
        self.watiHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        self.watiHUD!.dimBackground = true
        self.watiHUD!.color = UIColor.blackColor()
        self.watiHUD?.removeFromSuperViewOnHide = true
    }
    
    func hideWaitHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            self.watiHUD?.hideAnimated(true)
            self.watiHUD = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

