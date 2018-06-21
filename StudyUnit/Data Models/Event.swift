//
//  Event.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

struct Event {
    
    let LOCATION_KEY = "location"
    let DATE_KEY = "date"
    let DETAILS_KEY = "details"
    let TIME_KEY = "time"
    let NAME_KEY = "name"
    
    var location: String
    var time: String
    var courseName: String
    var name: String
    var date: NSDate?
    
    init(location: String, time: String, courseName: String, name: String, date: NSDate){
        self.location = location
        self.time = time
        self.courseName = courseName
        self.name = name
        self.date = date
    }
    
    init(fromJson json: [String : AnyObject]) {
        self.location = ""
        self.time = ""
        self.courseName = ""
        self.name = ""
        self.date = nil
        
        if let location = json[LOCATION_KEY] as? String {
            self.location = location
        }
        
        if let time = json[TIME_KEY] as? String {
            self.time = time
        }
        
        if let courseName = json[DETAILS_KEY] as? String {
            self.courseName = courseName
        }
        
        if let name = json[NAME_KEY] as? String {
            self.name = name
        }
        
        if let date = json[DATE_KEY] as? Double {
            self.date = NSDate(timeIntervalSince1970: date)
        }
    }
    
    func toJson() -> [String: Any] {
        return [
            LOCATION_KEY : self.location,
            TIME_KEY : self.time,
            NAME_KEY: self.name,
            DATE_KEY : self.date?.timeIntervalSince1970 ?? "nil",
        ]
    }
}
