//
//  show.swift
//  RadioTest
//
//  Created by ben on 5/3/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//

import UIKit

class Show{
    
    //MARK: Properties
    
    var name: String
    var dj: String
    var time: Int
    
    //MARK: Initialization
    
    init(name: String, dj:String , time: Int) {
        
        self.name = name
        self.dj = dj
        self.time = time
        
        if name.isEmpty {
            self.name = "Off Air"
            self.dj = ""
        }
    }
    
    
}
