//
//  User.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/17/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

struct User {
    
    let EMAIL_KEY = "email"
    let NAME_KEY = "name"
    let MAJOR_KEY = "major"
    let YEAR_KEY = "year"
    let COURSE_IDS_KEY = "courseIDs"
    let CHAR_IDS_KEY = "chatIDs"
   
    var userId: String
    var email: String
    var name: String
    var major: String
    var year: String
    var courseIDs: [String]
    var chatIDs: [String]
    
    init(email: String, name: String, major: String, year: String, courseIDs: [String], chatIDs: [String]) {
        self.userId = ""
        self.email = email
        self.name = name
        self.major = major
        self.year = year
        self.courseIDs = courseIDs
        self.chatIDs = chatIDs
    }
    
    init(fromJson json: [String : AnyObject]) {
        
        self.userId = ""
        self.email = ""
        self.name = ""
        self.major = ""
        self.year = ""
        self.courseIDs = []
        self.chatIDs = []
        
        if let email =  json[EMAIL_KEY] as? String {
            self.email = email
        }
        
        if let name = json[NAME_KEY] as? String {
            self.name = name
        }
        
        if let major = json[MAJOR_KEY] as? String {
            self.major = major
        }
        
        if let year = json[YEAR_KEY] as? String {
            self.year = year
        }
        
        if let courseIDs = json[COURSE_IDS_KEY] as? [String] {
            self.courseIDs = courseIDs
        }
        
        if let chatIDs = json[CHAR_IDS_KEY] as? [String] {
            self.chatIDs = chatIDs
        }
    }
    
    func toJson() -> [String : Any] {
        return [
            EMAIL_KEY: self.email,
            NAME_KEY: self.name,
            MAJOR_KEY: self.major,
            YEAR_KEY: self.year,
            COURSE_IDS_KEY: self.courseIDs,
            CHAR_IDS_KEY: self.chatIDs
        ]
    }
}
