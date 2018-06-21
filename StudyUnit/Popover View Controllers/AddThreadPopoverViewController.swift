//
//  AddThreadPopoverViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/20/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class AddThreadPopoverViewController: UIViewController {
    @IBOutlet var topicTextField: UITextField!
    @IBOutlet var threadTextField: UITextView!
    
    weak var addThreadDelegate: AddThreadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        threadTextField.layer.cornerRadius = 5
        threadTextField.layer.borderColor = UIColor.lightGray.cgColor
        threadTextField.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createThreadButton(_ sender: Any) {
       
        guard let topic = topicTextField.text, !topic.isEmpty else {
            self.displayAlert(title: "Topic Missing", message: "Please enter a topic for your thread")
            return
        }
    
        guard let post = threadTextField.text, !post.isEmpty else {
            self.displayAlert(title: "Post Missing", message: "Please enter content for your thread's post")
            return
        }
        
        Helper.getUserData { (user) in
            if let userModel = user {
                // generate thread + push to db
                let threadRef = THREADS_REF.childByAutoId()
                let threadId = threadRef.key
                let thread = CourseThread(originalPoster: userModel.name, numReplies: 0, topic: topic, post: post, timePosted: NSDate(), postIDs: [], threadId: threadId)
                
                threadRef.setValue(thread.toJson(), withCompletionBlock: { (err, ref) in
                    self.addThreadDelegate?.addThreadWithId(threadId: threadId)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}

//MARK: step 1 Add Protocol here.
protocol AddThreadDelegate: class {
    func addThreadWithId(threadId: String)
}
