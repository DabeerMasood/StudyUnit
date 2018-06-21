//
//  Thread.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/20/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

struct CourseThread {
    
    let ORIGINAL_POSTER_KEY = "originalPoster"
    let NUM_REPLIES_KEY = "numReplies"
    let TOPIC_KEY = "topic"
    let POST_KEY = "post"
    let TIME_POSTED_KEY = "timePosted"
    let POST_IDS_KEY = "postIds"
    let THREAD_ID = "threadId"
    let EVENT_IDS_KEY = "eventIDs"
    
    var originalPoster: String
    var numReplies: Int
    var topic: String
    var post: String
    var timePosted: NSDate?
    var postIDs: [String]
    var threadId: String
   
    init(originalPoster: String, numReplies: Int, topic: String, post: String, timePosted: NSDate?, postIDs: [String], threadId: String) {
        self.originalPoster = originalPoster
        self.numReplies = 0
        self.topic = topic
        self.post = post
        self.timePosted = timePosted
        self.postIDs = postIDs
        self.threadId = threadId
    }
    
    init(fromJson json: [String: AnyObject]) {
        self.originalPoster = ""
        self.numReplies = 0
        self.topic = ""
        self.post = ""
        self.timePosted = nil
        self.postIDs = []
        self.threadId = ""
        
        if let originalPoster = json[ORIGINAL_POSTER_KEY] as? String {
            self.originalPoster = originalPoster
        }
        
        if let numReplies = json[NUM_REPLIES_KEY] as? Int {
            self.numReplies = numReplies
        }
        
        if let topic = json[TOPIC_KEY] as? String {
            self.topic = topic
        }
        
        if let post = json[POST_KEY] as? String {
            self.post = post
        }
        
        if let timePosted = json[TIME_POSTED_KEY] as? Double {
            self.timePosted = NSDate(timeIntervalSince1970: timePosted)
        }
        
        if let postIDs = json[POST_IDS_KEY] as? [String] {
            self.postIDs = postIDs
        }
        
        if let threadId = json[THREAD_ID] as? String {
            self.threadId = threadId
        }
    }
    
    func toJson() -> [String: Any] {
        return [
            ORIGINAL_POSTER_KEY : self.originalPoster,
            NUM_REPLIES_KEY : self.numReplies,
            TOPIC_KEY : self.topic,
            POST_KEY : self.post,
            TIME_POSTED_KEY : self.timePosted?.timeIntervalSince1970 ?? "nil",
            POST_IDS_KEY : self.postIDs,
            THREAD_ID : self.threadId
        ]
    }
}
