//
//  AddEventPopoverViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class AddEventPopoverViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var ref: DatabaseReference!
    var addEventDelegate : AddEventDelegate?
    var course : Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = EVENTS_REF
        // Do any additional setup after loading the view.
        self.navigationController?.title = "Add Event"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(_ sender: UIButton) {
        
        guard let name = self.nameField.text, !name.isEmpty else {
            self.displayAlert(title: "Missing Name", message: "Please enter a name for the event")
            return
        }
        
        guard let location = self.locationField.text, !location.isEmpty else {
            self.displayAlert(title: "Missing Location", message: "Please enter a location for the event")
            return 
        }
        
        let date = datePicker.date as NSDate
        let event = Event(location: location, time: date.toShortTimeString(), courseName: self.course.courseId, name: name, date: date as NSDate)
        
        let eventRef = ref.childByAutoId()
        eventRef.setValue(event.toJson()) { (error, ref) in
            if(error == nil){
                self.addEventDelegate?.addEventToCourseWithId(eventId: eventRef.key, course: self.course)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.displayAlert(title: "Error Posting", message: "Somethign went wrong: \(error.debugDescription)")
            }
        }
        
    }
}

protocol AddEventDelegate: class {
    func addEventToCourseWithId(eventId: String, course: Course)
}
