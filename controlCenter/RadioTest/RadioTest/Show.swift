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
    var time: Int
    var len: Int
    //MARK: Initialization
    
    init(s: [String]) {
        name = s[0]
        dj = s[1]
        time = 0
        len = 1
    }
    public func setTime(t: Int, length: Int) {
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
