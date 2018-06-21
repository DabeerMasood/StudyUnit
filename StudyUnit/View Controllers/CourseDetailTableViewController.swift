//
//  GroupTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/20/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class CourseDetailTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, AddThreadDelegate {
    
    var course: Course!
    var threads: [String: CourseThread]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBar = self.tabBarController as? TabBarController {
            self.course = tabBar.selectedCourse
        }
        
        // pull threads
        threads = [String: CourseThread]()
        
        pullThreads()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pullThreads()
    }
    
    func pullThreads() {
        // pull threads using threadids + compose objects
        
       COURSES_REF.child(course.courseId).child("threadIds").observeSingleEvent(of: .value) { (snapshot) in
            if let threadIds = snapshot.value as? [String] {
                for threadId in threadIds {
                    if(!self.threads.keys.contains(threadId)){
                        THREADS_REF.child(threadId).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let json = snapshot.value as? [String : AnyObject] {
                                let thread = CourseThread(fromJson: json)
                                self.threads.updateValue(thread, forKey: threadId)
                                self.tableView.reloadData()
                            }
                        })
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
    
    func addThreadWithId(threadId: String) {
        // update groupid object as well
        
        let gKey = COURSES_REF.child(course.courseId)
        self.course.threadIDs.append(threadId)
        gKey.setValue(self.course.toJson()) { (error, ref) in
             // pull threads again
             self.pullThreads()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadTableViewCell", for: indexPath) as! ThreadTableViewCell

        // Configure the cell...
        let keys = Array(self.threads.keys)
        let thread = threads[keys[indexPath.row]]!
        let formatter = DateFormatter()
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: thread.timePosted! as Date)
        
        cell.nameLabel.text = thread.originalPoster
        cell.dateLabel.text = myStringafd
        cell.numRepliesLabel.text = thread.post
        cell.topicLabel.text = thread.topic

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAddThreadPopover" {
            let popoverViewController = segue.destination as! AddThreadPopoverViewController
            popoverViewController.popoverPresentationController?.delegate = self
            popoverViewController.addThreadDelegate = self
        }
        if segue.identifier == "showThreadSegue" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let vc = segue.destination as! ThreadTableViewController
                let keys = Array(self.threads.keys)
                let thread = threads[keys[indexPath.row]]!
                vc.thread = thread
            }
        }
    }
}
