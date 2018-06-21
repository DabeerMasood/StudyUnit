//
//  AddGroupPopoverViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/18/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class AddCoursePopoverViewController: UIViewController {

    @IBOutlet var classIdTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    //MARK: step 2 Create a delegate property here.
    weak var delegate: AddExistingCourseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGroupButton(_ sender: Any) {
        
        guard let courseId = classIdTextField.text, !courseId.isEmpty else {
            self.displayAlert(title: "Missing Name", message: "Please enter a course name")
            return
        }
        
        let courseTime = timePicker.date as NSDate
        
        // generate group + save to db
        // first, check whether user exists
       COURSES_REF.child(courseId).observeSingleEvent(of: .value, with: { (snapshot) in
            var course : Course!
            
            if !snapshot.exists() {
                // If the course does not exist create one and push it to the database
                let groupRef: DatabaseReference = COURSES_REF.child(courseId)
                course = Course(classId: courseId, courseTime: courseTime.toShortTimeString(), threadIDs: [], userIDs: [], eventIDs: [])
                let json = course.toJson()
                groupRef.setValue(json)
            } else {
                if let json = snapshot.value as? [String : AnyObject] {
                    course = Course(fromJSON: json)
                }
            }
            //Add the course to the users course list and dismiss the popover
            self.delegate?.addCourseWithId(courseId: courseId, course: course)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

//MARK: step 1 Add Protocol here.
protocol AddExistingCourseDelegate: class {
    func addCourseWithId(courseId: String, course: Course)
}
