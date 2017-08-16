//: Playground - noun: a place where people can play

import Foundation
import UIKit
import SwiftSoup
import Alamofire

class Show{
    
    //MARK: Properties
    
    var name: String
    var dj: String
    var time: String
    var len: Int
    //MARK: Initialization
    
    init(s: [String]) {
        name = s[0]
        dj = s[1]
        time = ""
        len = 1
    }
    public func setTime(t: String, length: Int) {
        time = t
        len = length
    }
    
    public func toString() -> String {
        return name + " - " + dj;
    }
    
    public func equals(o: Show) -> Bool {
        if (name == o.name) {
            return true;
        } else {
            return false;
        }
    }
}



var digSched = [[Show]]();
var fmSched = [[Show]]();
var shtuff: Elements;
var row = 0;
var col = 0;
var rowspan = -1;                            // how long a show is (2x)
var rowIndex = -1;                           // tracking the current row
var colTrack = [Int: Int]()
var none = [String]();
let offAir=Show(s: ["offAir","none"])
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
    
    try html = String(contentsOf: digUrl, encoding: .utf8)
    
//    print(html)
    
    
} catch {
    print(error);
}

do {
   
    try docDig = SwiftSoup.parse(html);
    
} catch {
    let URLBOI = "http://wmuc.umd.edu/station/schedule/0/2"
    docDig = Document(URLBOI)
    print(error);
}


do{
    shtuff = try docDig.select("td");
    
    for n in shtuff {
        do {
            
            try print(n.text())
            
            var a = try n.text().contains(":00")
            var b = try n.text().contains(":30")
            var c = try n.text().contains("Off The Air")
            var d = try n.text().contains("***")
            
            if( a || b ){
                daytracker = 0
                timetracker = try n.text()
            } else if(c){
                fmSched[daytracker].append(offAir)
            } else if d {
                var NewShow = try n.text().components(separatedBy:"***")
                fmSched[daytracker].append(Show(s: NewShow))
                var length = try n.attr("rowspan")
                var len = Int(length);
                fmSched[daytracker].last?.setTime(t: timetracker, length: len!)
                //print("COOL")
            }
            
            
            //try print(n.text())
            daytracker+=1
        } catch {
            print(error)
        }
    }
    
//    for r in 0...23 {
//        for c in 0...6 {
//            print(digSched[c][r]);
//            print(" | ");
//        }
//    }
    
} catch {
    print(error);
}

for iterator1 in fmSched{
    for iterator2 in iterator1 {
        print(iterator2.time)
        print(iterator2.name)
        print(iterator2.len)
    }
}

