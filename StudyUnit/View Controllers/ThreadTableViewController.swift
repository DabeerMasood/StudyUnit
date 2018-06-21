//
//  ThreadTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/21/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class ThreadTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, AddPostDelegate {

    var thread: CourseThread!
    var posts: [String : Post]!

    override func viewDidLoad() {
        super.viewDidLoad()

        posts = [String : Post]()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        pullPosts()
    }
    
    func pullPosts() {
        
        //get the most up to date verson of the thread
        THREADS_REF.child(self.thread.threadId).observe(.value) { (snapshot) in
            if let json = snapshot.value as? [String : AnyObject] {
                let thread = CourseThread(fromJson: json)
                for postId in thread.postIDs {
                    if(!self.posts.keys.contains(postId)) {
                        POSTS_REF.child(postId).observe(.value, with: { (snapshot) in
                            if let json = snapshot.value as? [String: AnyObject] {
                                let post = Post(fromJson: json)
                                self.posts.updateValue(post, forKey: postId)
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
    
    func addPostWithId(postId: String) {
        // update threadid object as well
        let gKey = THREADS_REF.child(thread.threadId)
        self.thread.postIDs.append(postId)
        gKey.setValue(self.thread.toJson()) { (error, ref) in
            // pull threads again
            self.pullPosts()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell

        // Configure the cell...
        let keys = Array(self.posts.keys)
        let post = self.posts[keys[indexPath.row]]!
        cell.userLabel.text = post.user
        cell.postLabel.text = post.post

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAddPostPopover" {
            let vc = segue.destination as! AddPostPopoverViewController
            vc.popoverPresentationController?.delegate = self
            vc.addPostDelegate = self
        }
    }

}
