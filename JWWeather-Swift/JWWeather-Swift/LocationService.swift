//
//  LocationService.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/10.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation

class LoactionService: NSObject,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    let locationService = BMKLocationService()
    var locationStart:(()->(Void))?
    var locationSucess:((city:String)->(Void))?
    var locationFail:(()->(Void))?
    
    
    override init() {
        super.init()
        locationService.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationService.distanceFilter = 100
        locationService.delegate = self
    }
    /**
     即将开始获取定位
     */
//    func willStartLocatingUser() {
//        locationStart!()
//    }
    /**
     更新地理位置
     
     - parameter userLocation: 位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        locationStart!()
        if userLocation.location != nil {
            locationService .stopUserLocationService()
            self.getCityName(userLocation)
        }
    }
    
    func didFailToLocateUserWithError(error: NSError!) {
        locationService .stopUserLocationService()
        locationFail!()
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
            locationSucess!(city: result.addressDetail.city)
        }
    }
    
    func locationServiceStart() {
        self.locationService.startUserLocationService()
    }
    
}