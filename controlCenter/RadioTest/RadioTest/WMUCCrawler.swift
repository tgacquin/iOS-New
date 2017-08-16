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
    //static public Schedule.Show[][] digSched = new Schedule.Show[7][24];
    //static public Schedule.Show[][] fmSched = new Schedule.Show[7][24];
    private var docDig: Document;
    private var docFM: Document;
    
    func main() {
        
        var shtuff: Elements;
        var row = 0;
        var col = 0;
        var rowspan = -1;                            // how long a show is (2x)
        var rowIndex = -1;                           // tracking the current row
        var colTrack = [Int: Int]()
        var none = [String]();
        var html: String!;
        let offAir=Show(s: ["offAir","none"])
        
        //Initializes the current row of each col in the sched as they may get out of order.
        colTrack.updateValue(0, forKey: 0);
        colTrack.updateValue(0, forKey: 1);
        colTrack.updateValue(0, forKey: 2);
        colTrack.updateValue(0, forKey: 3);
        colTrack.updateValue(0, forKey: 4);
        colTrack.updateValue(0, forKey: 5);
        colTrack.updateValue(0, forKey: 6);
        
        do {
            
            let digUrlString = "http://wmuc.umd.edu/station/schedule/0/2"
            guard let digUrl = URL(string: digUrlString) else {
                print("Error: \(digUrlString) doesn't seem to be a valid URL")
                return
            }
            let fmUrlString = "http://wmuc.umd.edu/station/schedule"
            guard let fmUrl = URL(string: fmUrlString) else {
                print("Error: \(fmUrlString) doesn't seem to be a valid URL")
                return
            }
            
            try html = String(contentsOf: digUrl, encoding: .utf8)
            do {
                try docDig = SwiftSoup.parse(html);
            } catch {
                print(error);
            }
        } catch {
            print(error);
        }
        
        
        do{
            shtuff = try docDig.select("td");
        } catch {
            print(error);
        
        }
        
        for n in shtuff {
            do {
                if (try !n.text().isEmpty && !(n.text().contains("Channel 2"))
                    && !(n.text().contains(":30"))
                    && !(n.text().contains("Get Involved Station History Donate"))
                    && !(n.text().contains("Find us on Facebook Follow WMUC"))) {
                    // sets the rowspan of the show
                    try rowspan = n.text().characters.index(of: "rowspan=\"");
                    if (rowspan != 8) {
                        if (n.text().charAt(rowspan + 1) != ("\"")) {
                            rowspan = Int(n.text().substring(rowspan, rowspan + 2))!;
                        } else {
                            rowspan = Int(n.text().substring(rowspan, rowspan + 1))!;
                        }
                    }
                    
                    if (try !n.text().contains(":00")) {
                        while (digSched[col][rowIndex].equals(o: offAir)) {
                            col = col + 1;
                        }
                    }
                    if (col < 7) {
                        row = colTrack[col]!;
                        while (row > rowIndex) {
                            col = col + 1;
                            row = colTrack[col]!;
                        }
                        for _ in 0 ..< (rowspan/2) {
                            let currShow: String = try n.text();
                            var curr = [String]();
                            curr = currShow.components(separatedBy: "\\*\\*\\*");
                            if (curr.count > 1) {
                                digSched[col][row] = Show(s: curr);
                                row = row + 1;
                            } else {
                                self.digSched[col][row] = Show(s: ["Off Air", "none"]);
                                row = row + 1;
                            }
                        }
                        colTrack.updateValue(row, forKey: col);
                        rowspan = -1;
                        if (col == 6) {
                            col = 0;
                        } else {
                            col = col + 1;
                        }
                        row = 0;
                    } else {
                        col = 0;
                    }
                }
                
                if (try n.text().contains(":00")) {
                    rowIndex = rowIndex + 1;
                    col = 0;
                }
            } catch {
                print(error)
            }
        }
        
        for r in 0...23 {
            for c in 0...6 {
                print(digSched[c][r]);
                print(" | ");
            }
            print();
        }
    }

    
    init(){
        main()
    }
}
