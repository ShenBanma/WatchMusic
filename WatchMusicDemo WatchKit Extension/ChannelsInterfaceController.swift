//
//  ChannelsInterfaceController.swift
//  WatchMusicDemo
//
//  Created by 沈家瑜 on 15/8/16.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Foundation


class ChannelsInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    let data = DataManager.instance
    
    var delegate: ReturnChannelsDelegate?
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let controller = context as? InterfaceController {
            self.delegate = controller
            controller.isPlay = true
        }
        
        table.setNumberOfRows(data.channelsData.count, withRowType: "channelsRow")
        
        for i in 0..<table.numberOfRows {
            let row = table.rowControllerAtIndex(i) as! ChannelsRow
            if let channel = data.channelsData[i]["name"].string {
                row.labelChannel.setText(channel)
            }
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let id = data.channelsData[rowIndex]["channel_id"].stringValue
        delegate?.returnChannels(id)
        dismissController()
    }

}

protocol ReturnChannelsDelegate {
    func returnChannels(index: String)
}