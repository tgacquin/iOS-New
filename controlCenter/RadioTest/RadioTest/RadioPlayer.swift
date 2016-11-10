//
//  RadioPlayer.swift
//  RadioTest
//
//  Created by Hwang Lee on 10/3/16.
//  Copyright © 2016 Hwang Lee. All rights reserved.
//

import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    private var digital = AVPlayer(url: NSURL(string: "http://wmuc.umd.edu/wmuc2-high.m3u")! as URL)
    private var fm = AVPlayer(url: NSURL(string: "http://wmuc.umd.edu/wmuc-high.m3u")! as URL)
    private var currentChannel = "FM"
    private var isPlaying = false
    

    func play() {
        if currentChannel == "FM" {
            digital.pause()
            fm.play()
        }
        
        else {
            fm.pause()
            digital.play()
        }
        isPlaying = true
    }
    
    func pause() {
        digital.pause()
        fm.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying {
            pause()
        }
        
        else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
    func getChannel() -> String {
        return currentChannel
    }
    
    func changePlaying(channel : String) {
        if(channel == "FM") {
            currentChannel = "FM"
        }
        
        else {
            currentChannel = "Digital"
        }
    }
    
    func refresh(){
        digital = AVPlayer(url: URL(string: "http://wmuc.umd.edu/wmuc2-high.m3u")!)
        fm = AVPlayer(url: URL(string: "http://wmuc.umd.edu/wmuc-high.m3u")!)
    }
    
}
