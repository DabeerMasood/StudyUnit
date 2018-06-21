//
//  SpecificPeopleTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 4/3/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class SpecificPeopleTableViewController: UITableViewController {
    
    var course: Course!
    var users: [String: User]!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBar = self.tabBarController as? TabBarController {
            self.course = tabBar.selectedCourse
        }

        users = [String: User]()
        
        // pull USER objects using sent classId
        pullUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pullUsers()
    }
    
    func pullUsers() {

        for userId in self.course.userIDs {
            USERS_REF.child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if let json = snapshot.value as? [String: AnyObject] {
                    let userData = User(fromJson: json)
                    if(!self.users.keys.contains(userId)){
                        self.users.updateValue(userData, forKey: userId)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleTableViewCell", for: indexPath) as! PeopleTableViewCell

        // Configure the cell...
        let keys = Array(self.users.keys)
        let user = self.users[keys[indexPath.row]]!
        cell.emailLabel.text = user.email
        cell.majorLabel.text = user.major
        cell.nameLabel.text = user.name
        cell.yearLabel.text = user.year

        return cell
    }
}
