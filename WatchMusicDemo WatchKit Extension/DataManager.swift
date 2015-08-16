//
//  DataManager.swift
//  WatchMusicDemo
//
//  Created by 沈家瑜 on 15/8/16.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Alamofire
import SwiftyJSON

class DataManager: NSObject {
    static let instance = DataManager()
    
    private override init() {}
    
    var songsData = [JSON]()
    
    var channelsData = [JSON]()
    
    var cacheImages: [String: NSNumber] {
        return WKInterfaceDevice.currentDevice().cachedImages as! [String: NSNumber]
    }
    
    //插入图片
    func addImage(url: String, imageView: WKInterfaceImage) {
        if let imageName = NSURL(string: url)?.path?.lastPathComponent{
            if hasImage(imageName) {
                imageView.setImageNamed(imageName)
            }else {
                var request:Alamofire.Request?
                request = Alamofire.request(.GET, url).response({ (req, _, data, error) -> Void in
                    if let e = error {
                        println("error: \(e)")
                    }else if req.URLString == request?.request.URLString {
                        let image = UIImage(data: data!)
                        self.addImageToCache(image!, imageName: imageName)
                        imageView.setImageNamed(imageName)
                    }
                    
                })
                
            }
        }
    }
    
    //检查缓存中是否存在图片
    func hasImage(imageName: String) ->Bool {
        return contains(cacheImages.keys, imageName)
    }
    
    //把图片插入缓存中
    func addImageToCache(image: UIImage, imageName: String) {
        var count = 0
        let device = WKInterfaceDevice.currentDevice()
        while device.addCachedImage(image, name: imageName) == false {
            count++
            if !removeImageFromCache() {
                device.removeAllCachedImages()
                device.addCachedImage(image, name: imageName)
                break
            }
            if count >= 50 {
                device.removeAllCachedImages()
                device.addCachedImage(image, name: imageName)
                break
            }
        }
    }
    
    //删除缓存
    func removeImageFromCache() ->Bool {
        let keysArray = cacheImages.keys
        if let keyName = keysArray.first {
            WKInterfaceDevice.currentDevice().removeCachedImageWithName(keyName)
            return true
        }
        return false
    }
    
    
}
