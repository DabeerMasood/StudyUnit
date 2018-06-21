//
//  PeopleTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masoxod. All rights reserved.
//

import UIKit
import Firebase

class PeopleTableViewController: UITableViewController {
    
    var courses: [String: Course]!
    var currClass: String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = [String: Course]()
        self.pullCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pullCourses()
    }
    
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
                            }
                            self.tableView.reloadData()
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseTableViewCell", for: indexPath) as! CourseTableViewCell
        
        let keys = Array(self.courses.keys)
        let course = self.courses[keys[indexPath.row]]!
        // Configure the cell...
        cell.classLabel.text = course.courseId
        cell.timeLabel.text = String(course.courseTime)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPeopleSegue" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let specificPeopleTableViewController = segue.destination as! SpecificPeopleTableViewController
                let keys = Array(self.courses.keys)
                specificPeopleTableViewController.course = self.courses[keys[indexPath.row]]!
            }
        }
    }

}
