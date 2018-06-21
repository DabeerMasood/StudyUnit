//
//  Helper.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/18/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

let BLUE_COLOR = UIColor(red: 8.0/255.0, green: 168.0/255.0, blue: 255.0/255.0, alpha: 1.0)

let COURSES_REF = Database.database().reference().child("courses")
let USERS_REF = Database.database().reference().child("users")
let POSTS_REF = Database.database().reference().child("posts")
let THREADS_REF = Database.database().reference().child("threads")
let EVENTS_REF = Database.database().reference().child("events")

class Helper {
    
    class func getUserData(completion: @escaping (User?) -> Void) {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if let json = snapshot.value as? [String : AnyObject] {
                    var userData = User(fromJson: json)
                    userData.userId = userId
                    completion(userData)
                }
            }
        }
    }
}


extension UIViewController {
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension NSDate {
    
    func hour() -> Int {
        //Get Hour
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: self as Date)
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int {
        //Get Minute
        let calendar = NSCalendar.current
        let minute = calendar.component(.minute, from: self as Date)
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self as Date)
        
        //Return Short Time String
        return timeString
    }
}
