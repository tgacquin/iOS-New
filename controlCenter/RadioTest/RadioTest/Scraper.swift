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

Alamofire.request(.GET, "http://wmuc.umd.edu")
    .responseString { response in
        print("Response String: \(response.result.value)")
}

let HTML = response.result.value

if let doc = HTML(html: html, encoding: .utf8) {
    print(doc.title)
    
    // Search for nodes by CSS
    for link in doc.css("a, link") {
        print(link.text)
        print(link["href"])
    }
    
    // Search for nodes by XPath
    for link in doc.xpath("//a | //link") {
        print(link.text)
        print(link["href"])
    }
}
