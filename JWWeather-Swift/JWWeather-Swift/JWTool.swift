//
//  JWTool.swift
//  JWWeather-Swift
//
//  Created by 董佳旺 on 16/9/11.
//  Copyright © 2016年 董佳旺. All rights reserved.
//

import Foundation
import GPUImage

class JWTool: NSObject {
    /**
     是否是白天
     
     - returns: 白天或者黑夜
     */
    func dayTime() -> Bool {
        let calendar = Calendar.current
        let hour = (calendar as NSCalendar).component(NSCalendar.Unit.hour, from: Date())
        if hour >= 18 || hour <= 06 {
            return false
        } else {
            return true
        }
    }
    
    /**
     高斯模糊图片
     
     - parameter image:      原图
     - parameter blurRadius: 模糊程度
     
     - returns: 模糊图
     */
    func createBlurBackground(_ image:UIImage,blurRadius:CGFloat) ->UIImage{
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = blurRadius
        let outputImage = blurFilter.image(byFilteringImage: image)
        if outputImage != nil {
            return outputImage!
        } else {
            return image
        }
    }
}
