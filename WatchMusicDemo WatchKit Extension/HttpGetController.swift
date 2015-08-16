//
//  HttpGetController.swift
//  WatchMusicDemo
//
//  Created by 沈家瑜 on 15/8/16.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Alamofire
import SwiftyJSON

class HttpGetController: NSObject {
    var delegate: GetJsonDelegate?
    func getInformation(url: String) {
        Alamofire.request(.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (_, _, json, error) -> Void in
            if let e = error {
                println("error: \(e)")
            }else {
                if let j: AnyObject = json {
                    self.delegate?.getJson(j)
                }
            }
        }
    }
}

protocol GetJsonDelegate {
    func getJson(json: AnyObject)
}