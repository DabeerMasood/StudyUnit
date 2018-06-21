//
//  CalendarTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 4/8/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

class CalendarTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, AddEventDelegate {

    var events : [String : Event]!
    var course : Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBar = self.tabBarController as? TabBarController {
            self.course = tabBar.selectedCourse
        }

        self.events = [String : Event]()
        self.pullEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pullEvents()
    }
    
    func pullEvents() {
        Helper.getUserData { (user) in
            if let user = user {
                for courseId in user.courseIDs {
                    COURSES_REF.child(courseId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let courseJson = snapshot.value as? [String : AnyObject] {
                            let course = Course(fromJSON: courseJson)
                            for eventIds in course.eventIDs {
                                EVENTS_REF.child(eventIds).observeSingleEvent(of: .value, with: { (snapshot) in
                                    if let eventJson = snapshot.value as? [String : AnyObject] {
                                        let event = Event(fromJson: eventJson)
                                        let eventKey = snapshot.key
                                        if(!self.events.keys.contains(eventKey)){
                                            self.events.updateValue(event, forKey: eventKey)
                                            self.tableView.reloadData()
                                        }
                                    }
                                })
                            }
                        }
                    })
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
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        let keys = Array(self.events.keys)
        let event = self.events[keys[indexPath.row]]!
        
        let formatter = DateFormatter()
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"

        cell.eventName.text = event.name
        cell.location.text = event.location
        cell.time.text = event.time
        cell.date.text = formatter.string(from: event.date! as Date)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addEventPopover" {
            if let popoverViewController = segue.destination as? AddEventPopoverViewController {
                popoverViewController.popoverPresentationController?.delegate = self
                popoverViewController.addEventDelegate = self
                popoverViewController.course = self.course
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func addEventToCourseWithId(eventId: String, course: Course) {
        var course = course
        course.eventIDs.append(eventId)
        
        COURSES_REF.child(course.courseId).setValue(course.toJson()) { (error, ref) in
            self.pullEvents()
        }
    }

}
