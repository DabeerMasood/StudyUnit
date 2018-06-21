//
//  TabBarController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/25/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var selectedCourse : Course!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ThreadsTableViewController") as! CourseDetailTableViewController
        let navController = UINavigationController(rootViewController: tableViewController)
        navController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "Courses_Icon"), tag: 0)
        
        let calendarViewController = self.storyboard!.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarTableViewController
        let navController0 = UINavigationController(rootViewController: calendarViewController)
        navController0.tabBarItem = UITabBarItem(title: "Calendar", image: #imageLiteral(resourceName: "Calendar_Icon"), tag: 0)
        
        let chatViewController = self.storyboard!.instantiateViewController(withIdentifier: "ChatTableViewController") as! ChatTableViewController
        let navController1 = UINavigationController(rootViewController: chatViewController)
        navController1.tabBarItem = UITabBarItem(title: "Chat", image: #imageLiteral(resourceName: "Chat_Icon"), tag: 0)

        let peopleViewController = self.storyboard!.instantiateViewController(withIdentifier: "PeopleTableViewController") as! SpecificPeopleTableViewController
        let navController2 = UINavigationController(rootViewController: peopleViewController)
        navController2.tabBarItem = UITabBarItem(title: "People", image: #imageLiteral(resourceName: "People_Icon"), tag: 0)
        
        let viewControllerList = [navController, navController0, navController1, navController2]
        
        viewControllers = viewControllerList
        
        self.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = BLUE_COLOR
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
