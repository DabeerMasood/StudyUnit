//
//  TableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/18/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CoursesTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, AddExistingCourseDelegate {
    
    var courses : [String : Course]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        courses = [String : Course]()
        
        pullCourses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pullCourses()
    }
    
    //Pull courses based on the users courseId list from firebase
    func pullCourses() {
        Helper.getUserData { (user) in
            if let userData = user {
                for courseId in userData.courseIDs {
                   COURSES_REF.child(courseId).observeSingleEvent(of: .value) { (snapshot) in
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: step 6 finally use the method of the contract
    func addCourseWithId(courseId: String, course: Course) {
        //add the courseId to the users list locally and then push to firebase
        var course = course
        Helper.getUserData { (user) in
            if var userData = user {
                userData.courseIDs.append(courseId)
                course.userIDs.append(userData.userId)
                
                //update the course model to have the user's id added to its userId array
                COURSES_REF.child(courseId).setValue(course.toJson())
                
                USERS_REF.child(userData.userId).setValue(userData.toJson(), withCompletionBlock: { (err, ref) in
                    self.pullCourses()
                })
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.00
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addCoursePopover" {
            let popoverViewController = segue.destination as! AddCoursePopoverViewController
            popoverViewController.popoverPresentationController?.delegate = self
            popoverViewController.delegate = self
        }
        
        if segue.identifier == "showCourseDetailSegue" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let tabBar = segue.destination as! TabBarController
                
                let keys = Array(self.courses.keys)
                let course = self.courses[keys[indexPath.row]]!
                tabBar.selectedCourse = course
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
