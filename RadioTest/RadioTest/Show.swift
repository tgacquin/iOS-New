//
//  show.swift
//  RadioTest
//
//  Created by ben on 5/3/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//


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
       // var semicolon = t.index(of: ":") ?? t.endIndex
//        var hour = Int(t[..<semicolon])!
//        if (t.contains("PM") && hour<12){
//            hour+=12
//        }
//        var min = 0
//        var mindex = t.index[after: semicolon]
//        if (t[mindex] == 3){
//            var min = 0.5
//        }

        time = t //hour+min
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
