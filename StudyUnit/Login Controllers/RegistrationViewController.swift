//
//  RegistrationViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/17/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    
    @IBOutlet var yearPickerView: UIPickerView!
    
    let years = ["Freshman", "Sophomore", "Junior", "Senior"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButton(_ sender: Any) {
    
        guard let email = self.emailTextField.text,!email.isEmpty else {
            self.displayAlert(title: "Whoops", message: "Please fill out all fields")
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.displayAlert(title: "Whoops", message: "Please fill out all fields")
            return
        }
        
        guard let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            self.displayAlert(title: "Whoops", message: "Please fill out all fields")
            return
        }
        
        guard let name = self.nameTextField.text, !name.isEmpty else {
           self.displayAlert(title: "Whoops", message: "Please fill out all fields")
            return
        }
        
        guard let major = self.majorTextField.text, !major.isEmpty else {
            self.displayAlert(title: "Whoops", message: "Please fill out all fields")
            return
        }
        
        let year = years[yearPickerView.selectedRow(inComponent: 0)]
        
        if confirmPassword != password {
            self.displayAlert(title: "Password Error", message: "Your passwords do not match")
            return
        }
        
        let userData = User(email: email, name: name, major: major, year: year, courseIDs: [], chatIDs: [])
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if(error == nil) {
                if let UID = user?.uid {
                    
                    let json = userData.toJson()
                    USERS_REF.child(UID).setValue(json, withCompletionBlock: { (err, ref) in
                        if(err == nil) {
                            self.dismiss(animated: true, completion: nil)
                        }else {
                            self.displayAlert(title: "Error Posting Data", message: err.debugDescription)
                        }
                    })
                    
                }
            } else {
                self.displayAlert(title: "Error Creating User", message: error.debugDescription)
            }
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
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
}
