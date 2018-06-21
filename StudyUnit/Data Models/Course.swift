//
//  Group.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/18/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Gloss

struct Course {
    
    let COURSE_ID_KEY = "courseId"
    let COURSE_TIME_KEY = "courseTime"
    let THREAD_IDS_KEY = "threadIds"
    let USER_IDS_KEY = "userIds"
    let EVENT_IDS_KEY = "eventIDs"
    
    var courseId: String
    var courseTime: String
    var threadIDs: [String]
    var userIDs: [String]
    var eventIDs: [String]
    
    init(fromJSON json: [String : AnyObject]) {
        
        self.courseId = ""
        self.courseTime = ""
        self.threadIDs = []
        self.userIDs = []
        self.eventIDs = []
        
        if let id = json[COURSE_ID_KEY] as? String {
            self.courseId = id
        }
        
        if let time = json[COURSE_TIME_KEY] as? String {
            self.courseTime = time
        }
        
        if let threads = json[THREAD_IDS_KEY] as? [String] {
            self.threadIDs = threads
        }
        
        if let userIDs = json[USER_IDS_KEY] as? [String] {
            self.userIDs = userIDs
        }
        
        if let eventIDs = json[EVENT_IDS_KEY] as? [String] {
            self.eventIDs = eventIDs
        }
    }
    
    init(classId: String, courseTime: String, threadIDs: [String], userIDs: [String], eventIDs: [String]){
        self.courseId = classId
        self.courseTime = courseTime
        self.threadIDs = threadIDs
        self.userIDs = userIDs
        self.eventIDs = eventIDs
    }
    
    func toJson() -> [String : Any] {
        return [
            COURSE_ID_KEY : courseId,
            COURSE_TIME_KEY : courseTime,
            THREAD_IDS_KEY : threadIDs,
            USER_IDS_KEY : userIDs,
            EVENT_IDS_KEY: self.eventIDs
        ]
    }
    
 
}

