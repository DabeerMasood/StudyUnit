//
//  AddPostPopoverViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/21/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class AddPostPopoverViewController: UIViewController {
    
    @IBOutlet var postTextView: UITextView!
    weak var addPostDelegate: AddPostDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postTextView.layer.cornerRadius = 5
        postTextView.layer.borderColor = UIColor.lightGray.cgColor
        postTextView.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButton(_ sender: Any) {
        
        guard let post = postTextView.text, !post.isEmpty else {
            self.displayAlert(title: "Missing Post", message: "Please add content for your post")
            return
        }
        
        Helper.getUserData { (user) in
            if let userData = user {
                // generate thread + push to db
                let postRef = POSTS_REF.childByAutoId()
                let postId = postRef.key
                let post = Post(user: userData.name, post: post, postIds: [])
                
                postRef.setValue(post.toJson(), withCompletionBlock: { (error, ref) in
                    if(error == nil){
                        self.addPostDelegate!.addPostWithId(postId: postId)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.displayAlert(title: "Post Failed", message: error.debugDescription)
                    }
                })
            }
        }
    }
}

//MARK: step 1 Add Protocol here.
protocol AddPostDelegate: class {
    func addPostWithId(postId: String)
}
