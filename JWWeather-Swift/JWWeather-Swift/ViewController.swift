//
//  ViewController.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/6.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    
    let locService = BMKLocationService()
    var watiHUD:MBProgressHUD?
    var subViews:MainView?
    var cityName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locService.desiredAccuracy = kCLLocationAccuracyBest;
        locService.distanceFilter = 100
        locService.delegate = self
        locService.startUserLocationService()
        
        subViews = MainView.init(frame: self.view.bounds)
        subViews?.mainViewRefreshWeather = {
            self.requestWeather(self.cityName!)
        }
        self.view.addSubview(subViews!)
    }
    
    /**
     更新地理位置
     
     - parameter userLocation: 位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if userLocation.location != nil {
            locService .stopUserLocationService()
            self.getCityName(userLocation)            
        }
    }
    
    func didFailToLocateUserWithError(error: NSError!) {
        self.showAlertCtrl("获取地理位置失败")
    }
    /**
     获取城市名称
     
     - parameter location: 定位到的location
     */
    func getCityName(location:BMKUserLocation) {

        let codeOption = BMKReverseGeoCodeOption()
        codeOption.reverseGeoPoint.latitude = location.location.coordinate.latitude
        codeOption.reverseGeoPoint.longitude = location.location.coordinate.longitude
                
        let codeSearch = BMKGeoCodeSearch()
        codeSearch.delegate = self
        
        if codeSearch.reverseGeoCode(codeOption) {
            watiHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            watiHUD!.dimBackground = true
            watiHUD!.color = UIColor.blackColor()
            watiHUD?.removeFromSuperViewOnHide = true
        }
    }
    /**
     反地理编码回调
     
     - parameter searcher:
     - parameter result:   解析结果
     - parameter error:    错误内容
     */
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            watiHUD!.hideAnimated(true)
            watiHUD = nil
            subViews?.cityName.text = result.addressDetail.city
            cityName = result.addressDetail.city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            self.requestWeather(cityName!)
        }
    }
    /**
     请求天气信息
     
     - parameter locCity: 城市名称
     */
    func requestWeather(locCity:String) {
        let url_0 = "http://api.map.baidu.com/telematics/v3/weather?location="
        let url_1 = "&output=json&ak=C3d2845360d091a5e8f42f605b7472ea"
        let urlStr = url_0 + locCity + url_1
        
        let url:NSURL = NSURL.init(string: urlStr)!
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let request = NSURLRequest.init(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if data?.length > 0 {
                    self.subViews?.analyzingNetData(data!)
                } else {
                    self.showAlertCtrl("获取天气信息失败")
                }
            }
        }
        task.resume()
    }
    
    /**
     弹出提示信息
     
     - parameter message: 信息内容
     */
    func showAlertCtrl(message:String) {
        let alertCtrl = UIAlertController.init(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addAction(UIAlertAction.init(title: "重新获取", style: UIAlertActionStyle.Default, handler: { (alert) in
            self.locService.startUserLocationService()
        }))
        alertCtrl.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

