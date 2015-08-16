//
//  InterfaceController.swift
//  WatchMusicDemo WatchKit Extension
//
//  Created by 沈家瑜 on 15/8/16.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import MediaPlayer

class InterfaceController: WKInterfaceController,GetJsonDelegate, ReturnSongsIndexDelegate , ReturnChannelsDelegate{
    
    @IBOutlet weak var labelRemind: WKInterfaceLabel!
    @IBOutlet weak var buttonPlay: WKInterfaceButton!
    @IBOutlet weak var labelInformation: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    var data = DataManager.instance
    
    var controller: HttpGetController!
    
    var currentIndex = 0
    
    var canRun = true
    
    let player = MPMoviePlayerController()
    
    var isPlay = false

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        controller = HttpGetController()
        controller.delegate = self
        self.changeViewState(true)
        controller.getInformation("http://www.douban.com/j/app/radio/channels")
        controller.getInformation("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        onSetImageAndOtherInformation(currentIndex)


    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func changeViewState(show: Bool) {
        image.setHidden(show)
        labelInformation.setHidden(show)
        labelRemind.setHidden(!show)
    }
    
    @IBAction func presentSongsList() {
        canRun = false
        isPlay = false
        self.presentControllerWithName("songsList", context: self)
    }
    @IBAction func presentChannelsList() {
        canRun = false
        isPlay = false
        self.presentControllerWithName("channelsList", context: self)
    }
    @IBAction func playOrPause() {
        if isPlay {
            isPlay = false
            buttonPlay.setBackgroundImageNamed("btnPlay")
            player.pause()
        } else {
            isPlay = true
            buttonPlay.setBackgroundImageNamed("btnPause")
            player.play()
        }
    }
    @IBAction func next() {
        isPlay = false
        currentIndex++
        if currentIndex >= data.songsData.count {
            currentIndex = 0
        }
        onSetImageAndOtherInformation(currentIndex)
    }
    @IBAction func pre() {
        isPlay = false
        currentIndex--
        if currentIndex < 0 {
            currentIndex = data.songsData.count - 1
        }
        onSetImageAndOtherInformation(currentIndex)
    }
    
    func playMusic(url: String) {
        player.stop()
        isPlay = false
        player.contentURL = NSURL(string: url)
        player.play()
        isPlay = true
    }
    
    func getJson(json: AnyObject) {
        let j = JSON(json)
        if let j1 = j["channels"].array {
            data.channelsData = j1
        }else if let j1 = j["song"].array {
            data.songsData = j1
            if canRun {
                onSetImageAndOtherInformation(0)
            }
        }
    }
    
    func onSetImageAndOtherInformation(index: Int) {
        if data.songsData.count != 0 && !isPlay{
            self.changeViewState(true)
            let json = data.songsData[index]
            if let imgURL = json["picture"].string, songName = json["title"].string, singer = json["artist"].string {
                labelInformation.setText("\(songName) - \(singer)")
                data.addImage(imgURL, imageView: image, competion: { () -> () in
                    self.changeViewState(false)
                })
            }
            if let musicURL = json["url"].string {
                playMusic(musicURL)
                buttonPlay.setBackgroundImageNamed("btnPause")
            }
        }
    }
    
    func returnSongsIndex(index: Int) {
        isPlay = false
        currentIndex = index
    }
    
    func returnChannels(index: String) {
        currentIndex = 0
        isPlay = false
        controller.getInformation("http://douban.fm/j/mine/playlist?type=n&channel=\(index)&from=mainsite")
    }

}
