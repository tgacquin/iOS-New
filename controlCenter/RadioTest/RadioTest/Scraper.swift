//
//  Scraper.swift
//  RadioTest
//
//  Created by ben on 3/29/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class scraper {

    func refresh(){
        
        if let doc = Kanna.HTML(url: (NSURL(string: "http://wmuc.umd.edu")!) as URL, encoding: .utf8) {
            
            print(doc);
            
    }
}
}
