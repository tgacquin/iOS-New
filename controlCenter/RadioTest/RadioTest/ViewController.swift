//
//  ViewController.swift
//  RadioTest
//
//  Created by Hwang Lee on 10/3/16.
//  Copyright © 2016 Hwang Lee. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    //MARK: UIButtons
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fm: UIButton!
    @IBOutlet weak var digital: UIButton!
    @IBOutlet weak var fmIcon: UIButton!
    @IBOutlet weak var digitalButton: UIButton!
    
    //MARK: UIImages
    var fmImage : UIImage = UIImage(named: "AlbumArtFM")!
    var digitalImage : UIImage = UIImage(named: "AlbumArtDigital")!
    
    //MARK: Size Properties
    let screenSize: CGRect = UIScreen.main.bounds
    let smallSizeIcon : CGFloat = 80
    let bigSizeIcon : CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        
        UIView.animate(withDuration: 0.0) {
            self.fmIcon.frame = CGRect(x: (self.view.frame.midX) - 100, y: self.screenSize.midY - 150, width: self.bigSizeIcon, height: self.bigSizeIcon)
            
            self.digitalButton.frame = CGRect(x: self.screenSize.width - self.digital.frame.width, y: self.screenSize.midY - (self.smallSizeIcon), width: self.smallSizeIcon, height: self.smallSizeIcon)
            
            self.digital.frame.origin.x = self.digitalButton.layer.frame.origin.x
            self.digital.frame.origin.y = self.digitalButton.frame.origin.y + 88
            
            self.fm.frame.origin.x = (self.view.frame.midX) - (self.fm.frame.size.width / 2)
            self.fm.frame.origin.y = self.fmIcon.layer.frame.origin.y + self.fmIcon.layer.frame.width + 10
        }
        
        playRadio()
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleInterruption(notification:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(ViewController.playRadio))
        commandCenter.pauseCommand.addTarget(self, action: #selector(ViewController.pauseRadio))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(ViewController.nextChannel))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(ViewController.nextChannel))
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : RadioPlayer.sharedInstance.getChannel(), MPMediaItemPropertyArtist : "WMUC", MPMediaItemPropertyArtwork : MPMediaItemArtwork(image: fmImage)]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        toggle()
    }
    
    func toggle() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        }
        else {
            playRadio()
        }
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        playButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
    }
    
    @IBAction func fmPressed(_ sender: UIButton) {
        toggleAnimation(channel: "FM")
        RadioPlayer.sharedInstance.changePlaying(channel: "FM")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        //fm.setTitle("Selected", for: .normal)
        //digital.setTitle("Digital", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func fmIconPressed(_ sender: UIButton?) {
        toggleAnimation(channel: "FM")
        RadioPlayer.sharedInstance.changePlaying(channel: "FM")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        //fm.setTitle("Selected", for: .normal)
        //digital.setTitle("Digital", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func digitalPressed(_ sender: UIButton) {
        toggleAnimation(channel: "Digital")
        RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        //digital.setTitle("Selected", for: .normal)
        //fm.setTitle("FM", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func digitalIconPressed(_ sender: UIButton?) {
        toggleAnimation(channel: "Digital")
        RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        //digital.setTitle("Selected", for: .normal)
        //fm.setTitle("FM", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    func toggleAnimation(channel : String){
        if channel == "Digital" {
            if RadioPlayer.sharedInstance.getChannel() == "FM" {
                //perform animation
                UIView.animate(withDuration: 0.2) {
                    self.fmIcon.frame = CGRect(x: 0, y: self.screenSize.midY - (self.smallSizeIcon), width: self.smallSizeIcon, height: self.smallSizeIcon)
                    self.digitalButton.frame = CGRect(x: (self.view.frame.midX) - 100, y: self.screenSize.midY - 150, width: self.bigSizeIcon, height: self.bigSizeIcon)
                    
                    self.fm.frame.origin.x = self.fmIcon.layer.frame.origin.x
                    self.fm.frame.origin.y = self.fmIcon.frame.origin.y + 88
                    
                    self.digital.frame.origin.x = (self.view.frame.midX) - (self.fm.frame.midX)
                    self.digital.frame.origin.y = self.digitalButton.layer.frame.origin.y + self.digitalButton.layer.frame.width + 10
                    
                }
            }
        } else if channel == "FM" {
            if RadioPlayer.sharedInstance.getChannel() == "Digital" {
                //perform animation
                UIView.animate(withDuration: 0.2) {
                    self.fmIcon.frame = CGRect(x: (self.view.frame.midX) - 100, y: self.screenSize.midY - 150, width: self.bigSizeIcon, height: self.bigSizeIcon)
                    self.digitalButton.frame = CGRect(x: (self.screenSize.width) - (self.digital.frame.width), y: self.screenSize.midY - (self.smallSizeIcon), width: self.smallSizeIcon, height: self.smallSizeIcon)
                    
                    self.digital.frame.origin.x = self.digitalButton.layer.frame.origin.x
                    self.digital.frame.origin.y = self.digitalButton.frame.origin.y + 88
                    
                    self.fm.frame.origin.x = (self.view.frame.midX) - (self.fm.frame.midX)
                    self.fm.frame.origin.y = self.fmIcon.layer.frame.origin.y + self.fmIcon.layer.frame.width + 10
                    
                }
            }
        }
    }
    
    func nextChannel() {
        if RadioPlayer.sharedInstance.getChannel() == "FM" {
            RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
            
            if RadioPlayer.sharedInstance.currentlyPlaying() {
                playRadio()
            }
            
            //digital.setTitle("Selected", for: .normal)
            //fm.setTitle("FM", for: .normal)
            
        }
        else {
            RadioPlayer.sharedInstance.changePlaying(channel: "FM")
            
            if RadioPlayer.sharedInstance.currentlyPlaying() {
                playRadio()
            }
            
            //fm.setTitle("Selected", for: .normal)
            //digital.setTitle("Digital", for: .normal)
        }
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    func updateMediaProperty(channel : String) {
        let artwork = (channel == "FM") ? MPMediaItemArtwork(image: fmImage) : MPMediaItemArtwork(image: digitalImage)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : channel, MPMediaItemPropertyArtist : "WMUC", MPMediaItemPropertyArtwork :artwork]
    }
    
    
    func handleInterruption(notification: NSNotification) {
        
        //guard let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType else { print("wrong type"); return }
        
        if notification.name != NSNotification.Name.AVAudioSessionInterruption
            || notification.userInfo == nil{
            return
        }
        
        var info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let interruptionType = AVAudioSessionInterruptionType(rawValue: intValue) {
            
            switch interruptionType {
                
            case .began:
                print("began")
                // player is paused and session is inactive. need to update UI)
                pauseRadio()
                print("audio paused")
                
            default:
                print("ended")
                /** /
                 if let option = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions where option == .ShouldResume {
                 // ok to resume playing, re activate session and resume playing
                 // need to update UI
                 player.play()
                 print("audio resumed")
                 }
                 / **/
                playRadio()
                print("audio resumed")
            }
        }
    }
    
    @IBAction func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        let swipeGesture = gesture
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            fmIconPressed(nil)
        case UISwipeGestureRecognizerDirection.left:
            digitalIconPressed(nil)
        default:
            break
        }
        
        
    }
    
}

