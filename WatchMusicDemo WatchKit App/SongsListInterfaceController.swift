//
//  SongsListInterfaceController.swift
//  WatchMusicDemo
//
//  Created by 沈家瑜 on 15/8/16.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Foundation


class SongsListInterfaceController: WKInterfaceController {
    
    var delegate: ReturnSongsIndexDelegate?
    
    var data = DataManager.instance

    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let controller = context as? InterfaceController {
            self.delegate = controller
            controller.isPlay = true
        }
        table.setNumberOfRows(data.songsData.count, withRowType: "songList")
        for i in 0..<table.numberOfRows {
            let row = table.rowControllerAtIndex(i) as! SongsListTableRow
            let json = data.songsData[i]
            if let songName = json["title"].string, singer = json["artist"].string, imgURL = json["picture"].string {
                row.labelSinger.setText(singer)
                row.labelSongName.setText(songName)
                data.addImage(imgURL, imageView: row.image)
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
        delegate?.returnSongsIndex(rowIndex)
        dismissController()
    }

}

protocol ReturnSongsIndexDelegate {
    func returnSongsIndex(index: Int)
}
