//
//  ViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/17/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                let courseView = self.storyboard!.instantiateViewController(withIdentifier: "CoursesTableViewController") as! CoursesTableViewController
                self.present(courseView, animated:true, completion: nil)
            }else{
                print("No USER displaying login page...")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    // check credentials + login
    @IBAction func loginButton(_ sender: Any) {
       
        guard let email = self.emailTextField.text, !email.isEmpty else {
            self.displayAlert(title: "Missing Email", message: "Please enter a valid email address")
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.displayAlert(title: "Missing Password", message: "Please enter your password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if(error == nil){
                let courseView = self.storyboard!.instantiateViewController(withIdentifier: "CoursesTableViewController") as! CoursesTableViewController
                self.present(courseView, animated:true, completion: nil)
            }else {
                self.displayAlert(title: "Login Error", message: "Something went wrong :(")
                print(error.debugDescription)
            }
        }
    }
}

