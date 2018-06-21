//
//  CalendarViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/25/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var detailsTextField: UITextView!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    var user: User!

    var events: [Date:Event]!
    
    var currEvent: Event!
    var currDate: Date!
    
    var ref: DatabaseReference!
    
    var currClass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsTextField.text = ""
        statusLabel.text = ""
        ref = Database.database().reference()
        events = [:]
        
        // pull all created events + populate data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchClass(classId: String) {
        // pull groups using groupids + compose objects
//        currClass = classId
//        self.events = [:]
//        ref.child("events").child(currClass).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                let value = rest.value as? NSDictionary
//                var currEvent = Event(location: "", date: "", details: "", calendarDate: nil)
//
//                let location = value?["location"] as? String ?? ""
//                let date = value?["date"] as? String ?? ""
//                let details = value?["details"] as? String ?? ""
//                let calendarDate = value?["calendarDate"] as? Double ?? nil
//
//                currEvent.location = location
//                currEvent.date = date
//                currEvent.details = details
//
//                if let d = calendarDate {
//                    currEvent.calendarDate = NSDate(timeIntervalSince1970: d)
//                }
//
//                self.events[currEvent.calendarDate! as Date] = currEvent
//            }
//            self.calendarView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    @IBAction func addEventButton(_ sender: Any) {
//        var event = Event(location: "", date: "", details: "", calendarDate: nil)
//        if let date = currDate {
//            event.calendarDate = date as NSDate
//        }
//        event.location = locationTextField.text!
//        event.date = timeTextField.text!
//        event.details = detailsTextField.text!
//
//        let eventRef = ref.child("events").child(currClass).childByAutoId()
//        let evnt = ["location":event.location,
//                    "date":event.date,
//                    "details":event.details,
//                    "calendarDate":event.calendarDate!.timeIntervalSince1970] as [String : Any]
//        eventRef.setValue(evnt)
//        events[event.calendarDate! as Date] = event
//
//        statusLabel.text = "completed"
//        locationTextField.text = ""
//        timeTextField.text = ""
//        detailsTextField.text = ""
//
//        self.calendarView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEventPopover" {
            let popoverViewController = segue.destination as! AddEventPopoverViewController
            popoverViewController.popoverPresentationController?.delegate = self
            //popoverViewController.event = currEvent
            print("segue occurred")
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        }
        else {
            cell.selectedView.isHidden = true
        }
        
        if events[date] != nil {
            cell.backgroundColor = UIColor.cyan
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = false
        self.currEvent = events[date]
        self.currDate = date
        print("user selected")
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = true
        self.currEvent = nil
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
}
