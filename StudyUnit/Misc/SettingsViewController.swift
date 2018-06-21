//
//  SettingsViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/20/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var user: User!
    
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var yearPicker: UIPickerView!
    
    let years = ["Freshman", "Sophomore", "Junior", "Senior"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        self.nameTextField.delegate = self
        self.majorTextField.delegate = self
        
        self.pullUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullUser() {
        Helper.getUserData { (user) in
            if let user = user {
                
                self.user = user
                self.nameTextField.text = user.name
                self.majorTextField.text = user.major
                
                switch user.year {
                case "Freshman":
                    self.yearPicker.selectRow(0, inComponent: 0, animated: true)
                    break
                case "Sophomore":
                    self.yearPicker.selectRow(1, inComponent: 0, animated: true)
                    break
                case "Junior":
                    self.yearPicker.selectRow(2, inComponent: 0, animated: true)
                    break
                case "Senior":
                    self.yearPicker.selectRow(3, inComponent: 0, animated: true)
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            self.displayAlert(title: "Missing Name", message: "Please enter your name")
            return
        }
        
        guard let major = self.majorTextField.text, !major.isEmpty else {
            self.displayAlert(title: "Missing Major", message: "Please enter your major")
            return
        }
        
        self.user.name = name
        self.user.major = major
        self.user.year = self.years[self.yearPicker.selectedRow(inComponent: 0)]
        
        USERS_REF.child(self.user.userId).setValue(self.user.toJson()) { (error, ref) in
            if(error == nil){
                self.navigationController?.popViewController(animated: true)
            } else{
                self.displayAlert(title: "Error Saving", message: error.debugDescription)
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch {
            self.displayAlert(title: "Error", message: "Something went wrong trying to log out")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
