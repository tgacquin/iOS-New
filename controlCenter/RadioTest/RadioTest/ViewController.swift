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
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fm: UIButton!
    @IBOutlet weak var digital: UIButton!
    @IBOutlet weak var fmIcon: UIButton!
    @IBOutlet weak var digitalButton: UIButton!
    
    var fmImage : UIImage = UIImage(named: "AlbumArtFM")!
    var digitalImage : UIImage = UIImage(named: "AlbumArtDigital")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        
        fm.setTitle("Selected", for: .normal)
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
        RadioPlayer.sharedInstance.changePlaying(channel: "FM")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        fm.setTitle("Selected", for: .normal)
        digital.setTitle("Digital", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func fmIconPressed(_ sender: UIButton) {
        RadioPlayer.sharedInstance.changePlaying(channel: "FM")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        fm.setTitle("Selected", for: .normal)
        digital.setTitle("Digital", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func digitalPressed(_ sender: UIButton) {
        RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        digital.setTitle("Selected", for: .normal)
        fm.setTitle("FM", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    @IBAction func digitalIconPressed(_ sender: UIButton) {
        RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playRadio()
        }
        
        digital.setTitle("Selected", for: .normal)
        fm.setTitle("FM", for: .normal)
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    func nextChannel() {
        if RadioPlayer.sharedInstance.getChannel() == "FM" {
            RadioPlayer.sharedInstance.changePlaying(channel: "Digital")
            
            if RadioPlayer.sharedInstance.currentlyPlaying() {
                playRadio()
            }
            
            digital.setTitle("Selected", for: .normal)
            fm.setTitle("FM", for: .normal)
            
        }
        else {
            RadioPlayer.sharedInstance.changePlaying(channel: "FM")
            
            if RadioPlayer.sharedInstance.currentlyPlaying() {
                playRadio()
            }
            
            fm.setTitle("Selected", for: .normal)
            digital.setTitle("Digital", for: .normal)
        }
        
        updateMediaProperty(channel: RadioPlayer.sharedInstance.getChannel())
    }
    
    func updateMediaProperty(channel : String) {
        let artwork = (channel == "FM") ? MPMediaItemArtwork(image: fmImage) : MPMediaItemArtwork(image: digitalImage)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : channel, MPMediaItemPropertyArtist : "WMUC", MPMediaItemPropertyArtwork :artwork]
    }
}

