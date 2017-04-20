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

    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            // Search for nodes by CSS selector
            for show in doc.css("td[id^='Text']") {
                shtuff = doc.select("td");
                for(Element n : shtuff){
                    if (!n.text().isEmpty()&&!(n.text().contains("Channel 2"))
                        &&!(n.text().contains(":30"))
                        &&!(n.text().contains("Get Involved Station History Donate"))
                        &&!(n.text().contains("Find us on Facebook Follow WMUC"))) {
                        entireSchedule.add(n.text());
                    }
                }
            } catch (MalformedURLException mue) {
                mue.printStackTrace();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
            
            int row = -1;
            int col = 0;
            
            for(String s : entireSchedule) {
                
                if(s.contains(":00")){
                    row++;
                }
                else{
                    String [] a = s.split("\\*\\*\\*");
                    if(a.length>1)
                    sched[row][col] = new Show (a);
                    col = (col+1)%7;
                }
            }
            
            for(int r = 0; r <24; r++){
                for(int c = 0; c < 1; c++){
                    System.out.print(sched[r][c] + " | ");
                }
                System.out.println();
            }
            
        }

                
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // All text involving shows on this page currently start with the weekday.
                // Weekday formatting is inconsistent, but the first three letters are always there.
                let regex = try! NSRegularExpression(pattern: "^(mon|tue|wed|thu|fri|sat|sun)", options: [.caseInsensitive])
                
                if regex.firstMatch(in: showString, options: [], range: NSMakeRange(0, showString.characters.count)) != nil {
                    shows.append(showString)
                    print("\(showString)\n")
                }
        }
        
    }
    
    
    func refresh() -> Void {
        
            Alamofire.request("http://wmuc.umd.edu").responseString { response in
                print("\(response.result.isSuccess)")
                if let html = response.result.value {
                    self.parseHTML(html: html)
                }
            }
        
        
        
        
        if let doc = Kanna.HTML(url: (NSURL(string: "http://wmuc.umd.edu")!) as URL, encoding: .utf8) {
            
            ArrayList<Element> shtuff;
            ArrayList<String> entireSchedule = new ArrayList<String>();
            Show [] [] sched = new Show [24][7];
            
            try {
            doc = Jsoup.connect("http://www.wmuc.umd.edu/station/schedule/0/2").get();
            shtuff = doc.select("td");
            for(Element n : shtuff){
            if (!n.text().isEmpty()&&!(n.text().contains("Channel 2"))
            &&!(n.text().contains(":30"))
            &&!(n.text().contains("Get Involved Station History Donate"))
            &&!(n.text().contains("Find us on Facebook Follow WMUC"))) {
            entireSchedule.add(n.text());
            }
            }
            } catch (MalformedURLException mue) {
            mue.printStackTrace();
            } catch (IOException ioe) {
            ioe.printStackTrace();
            }
            
            int row = -1;
            int col = 0;
            
            for(String s : entireSchedule) {
                
                if(s.contains(":00")){
                    row++;
                }
                else{
                    String [] a = s.split("\\*\\*\\*");
                    if(a.length>1)
                    sched[row][col] = new Show (a);
                    col = (col+1)%7;
                }
            }
            
            for(int r = 0; r <24; r++){
                for(int c = 0; c < 1; c++){
                    System.out.print(sched[r][c] + " | ");
                }
                System.out.println();
            }
            
        }
        
        
        
        
}
}

 class Show {
    String sName;
    String host;
    
    func Show(String [] s){
    sName = s[0];
    host = s[1];
    }
    
    let String getShow(){
    return sName;
    }
    
    public String getHost(){
    return host;
    }
    public String toString(){
    return sName + " - " + host;
    }
}
