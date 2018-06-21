//
//  CourseSelectTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 4/10/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class CourseSelectTableViewController: UITableViewController {

    var ref: DatabaseReference!
    var courses : [String : Course]!
    var addEventDelegate : AddEventDelegate?
    var selectedCourse : Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        courses = [String : Course]()
        
        pullCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Pull courses based on the users courseId list from firebase
    func pullCourses() {
        Helper.getUserData { (user) in
            if let userData = user {
                for courseId in userData.courseIDs {
                    self.ref.child("courses").child(courseId).observeSingleEvent(of: .value) { (snapshot) in
                        if let json = snapshot.value as? [String : AnyObject] {
                            let course = Course(fromJSON: json)
                            let courseId = snapshot.key
                            if(!self.courses.keys.contains(courseId)) {
                                self.courses.updateValue(course, forKey: courseId)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseTableViewCell", for: indexPath) as! CourseTableViewCell
        
        // Configure the cell...
        let keys = Array(self.courses.keys)
        let course = self.courses[keys[indexPath.row]]!
        cell.classLabel.text = course.courseId
        cell.timeLabel.text = String(course.courseTime)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keys = Array(self.courses.keys)
        let course = self.courses[keys[indexPath.row]]!
        self.selectedCourse = course
        self.performSegue(withIdentifier: "detailSelectSegue", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailSelectSegue" {
            let popoverViewController = segue.destination as! AddEventPopoverViewController
            popoverViewController.addEventDelegate = self.addEventDelegate
            popoverViewController.course = self.selectedCourse
        }
    }
    

}
