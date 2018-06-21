//
//  Post.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/21/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

struct Post {
    
    let USER_KEY = "user"
    let POST_KEY = "post"
    let POST_IDS_KEY = "postIds"
    
    var user: String
    var post: String
    var postIds: [String]
   
    init(user: String, post: String, postIds: [String]) {
        self.user = user
        self.post = post
        self.postIds = postIds
    }
    
    init(fromJson json: [String: AnyObject]){
        self.user = ""
        self.post = ""
        self.postIds = []
        
        if let user = json[USER_KEY] as? String {
            self.user = user
        }
        
        if let post = json[POST_KEY] as? String {
            self.post = post
        }
        
        if let postIds = json[POST_IDS_KEY] as? [String] {
            self.postIds = postIds
        }
    }
    
    func toJson() -> [String : Any]{
        return [
            USER_KEY : self.user,
            POST_KEY : self.post,
            POST_IDS_KEY : self.postIds
        ]
    }
}
