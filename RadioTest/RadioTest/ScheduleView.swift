//
//  ScheduleView.swift
//  RadioTest
//
//  Created by ben on 3/8/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//

import UIKit


let DayNotificationKey = "DayChangedKey"
let ChannelNotificationKey = "Channel"

class ScheduleView: UIViewController {
    
    let daysArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FMselect.isSelected = true
        viewerSetting="FM"
        
        
        self.DayLabel.text=daysArray[self.daysel.selectedSegmentIndex]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.Swipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.Swipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var DayLabel: UILabel!
    
    @IBOutlet weak var daysel: UISegmentedControl!
    
    @IBOutlet weak var dot: UIImageView!
  
    @IBOutlet weak var FMselect: UIButton!
    
    @IBOutlet weak var Digselect: UIButton!
    
    @IBAction func FMselected(_ sender: Any) {
        viewerSetting = "FM"
        FMselect.isSelected = true
        Digselect.isSelected = false
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            var dot = self.dot.frame
            dot.origin.x = self.FMselect.frame.midX - (0.5 * dot.width)
            
            self.dot.frame=dot
        })
         NotificationCenter.default.post(name: Notification.Name(rawValue: ChannelNotificationKey), object: self)
    }
    

    @IBAction func digsel(_ sender: Any) {
        viewerSetting = "Dig"
        FMselect.isSelected = false
        Digselect.isSelected = true
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            var dot = self.dot.frame
            dot.origin.x = self.Digselect.frame.midX - (0.5 * dot.width)
            
            self.dot.frame=dot
        })
        
         NotificationCenter.default.post(name: Notification.Name(rawValue: ChannelNotificationKey), object: self)
        
    }
    
    
    @IBAction func Swipe(_ gesture: UISwipeGestureRecognizer) {
        let swipeGesture = gesture
        
        print("SWIPE")

        
        
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            digsel(gesture)
        case UISwipeGestureRecognizerDirection.left:
            FMselected(gesture)
        default:
            break
        }
        
    }
    
    
    @IBAction func setDay(_ sender: Any) {
        let dayValue: [AnyHashable: Any] = [AnyHashable("dayVal"): daysel.selectedSegmentIndex]
        
        self.DayLabel.text=daysArray[self.daysel.selectedSegmentIndex]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: DayNotificationKey), object: self, userInfo: dayValue)
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToPlayerWithSegue", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
