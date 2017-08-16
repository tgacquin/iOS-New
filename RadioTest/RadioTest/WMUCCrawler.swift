//
//  WMUCCrawler.swift
//  RadioTest
//
//  Created by ben on 7/21/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class WMUCCrawler {
    
    
    public var digSched = [[Show]]();
    public var fmSched = [[Show]]();

    
    init(){
        var digSched = [[Show]]();
        var fmSched = [[Show]]();
        var shtuff: Elements;
        var row = 0;
        var col = 0;
        var rowspan = -1;                            // how long a show is (2x)
        var colTrack = [Int: Int]()
        let offAir=["offAir","none"]
        var docDig: Document;
        var docFM: Document;
        var timetracker = "00:00 AM"
        var daytracker = 0;
        var day = [Show]()
        
        for i in 0...7 {
            digSched.append(day)
            fmSched.append(day)
        }
        
        //var sun = [Show]()
        //var mon = [Show]()
        //var tue = [Show]()
        //var wed = [Show]()
        //var thu = [Show]()
        //var fri = [Show]()
        //var sat = [Show]()
        
        
        //Initializes the current row of each col in the sched as they may get out of order.
        colTrack.updateValue(0, forKey: 0);
        colTrack.updateValue(0, forKey: 1);
        colTrack.updateValue(0, forKey: 2);
        colTrack.updateValue(0, forKey: 3);
        colTrack.updateValue(0, forKey: 4);
        colTrack.updateValue(0, forKey: 5);
        colTrack.updateValue(0, forKey: 6);
        var html: String!;
        
        do {
            
            let digUrlString = "http://wmuc.umd.edu/station/schedule/"
            guard let digUrl = URL(string: digUrlString) else {
                print("Error: \(digUrlString) doesn't seem to be a valid URL")
                throw NSError.init()
            }
            //    let fmUrlString = "http://wmuc.umd.edu/station/schedule"
            //    guard let fmUrl = URL(string: fmUrlString) else {
            //        print("Error: \(fmUrlString) doesn't seem to be a valid URL")
            //        return
            //    }
            
            html = try! String(contentsOf: digUrl, encoding: .utf8) //get the HTML
            
            //    print(html)
            
            
        } catch {
            print(error);
        }
        
        do {
            
            try docDig = SwiftSoup.parse(html); // load up the old Parsed Document
            
        } catch {
            let URLBOI = "http://wmuc.umd.edu/station/schedule"
            docDig = Document(URLBOI) /// make sure it actually happens lol
            print(error);
        }
        
        
        do{
            shtuff = try docDig.select("td"); // select all the 'TD' elements
            
            for n in shtuff {
                var x = try n.text().contains("Find us on Facebook Follow WMUC on Twitter!") //  if it's one of these not-important ones, ignore it dude.
                var y = try n.text().contains("Previous Schedules for Channel 1Spring 2006 (01/30/06")
                var z = try n.text().contains("Get Involved")
                var e = (try n.text().characters.count == 0)
                
                
                if(x || y || z || e ){ //ignore the ones that don't matter
                    
                }else{
                    do {
                        print("|")
                        try print(n.text())
                        
                        var a = try n.text().contains(":00") // if it's a time, do one thing
                        var b = try n.text().contains(":30")
                        var c = try n.text().contains("Off The Air") // if it's off air, do another
                        var d = try n.text().contains("***") // if it's a show, do another thing
                        
                        if( a || b ){
                            daytracker = 0 // if it's the time, set the day to sunday,
                            timetracker = try n.text() // set the time for the shows we get during this slot
                        } else if(c){
                            fmSched[daytracker].append(Show(s: offAir)) // if it's off air, put a new off air show on
                            var length = try n.attr("rowspan") // use the rowspan to get how many half-hour blocks the show takes up
                            var len = Int(length)!;
                            fmSched[daytracker].last?.setTime(t: timetracker, length: len) //set the show's time info
                            colTrack.updateValue(len, forKey: daytracker) // update that we have a show in this column for the next (len) half hour blocks.
                        } else if d {
                            var NewShow = try n.text().components(separatedBy:"***") // get the various components: name *** dj *** etc
                            fmSched[daytracker].append(Show(s: NewShow)) // add the new show in
                            var length = try n.attr("rowspan") // get in thew new length info
                            var len = Int(length)!;
                            fmSched[daytracker].last?.setTime(t: timetracker, length: len)// update that we have a show in this column for the next (len) half hour blocks.
                            colTrack.updateValue(len, forKey: daytracker)
                        }
                        
                        
                        //try print(n.text())
                        while(colTrack[daytracker] != 0){ //function to set what day the next show we get should plop into.
                            if(daytracker>6){ // if we go thru the entire week, then reset to prevent array overrun
                                break
                            }
                            var curVal = colTrack[daytracker]!
                            colTrack.updateValue((curVal-1), forKey: daytracker)
                            daytracker+=1
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            
        } catch {
            print(error);
        }
    }
}
