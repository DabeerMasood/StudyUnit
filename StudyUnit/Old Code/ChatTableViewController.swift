//
//  ChatTableViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UITableViewController {
    
    var user: User!
    var chats: [Chat]!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // pull all chats
        chats = []
        ref = Database.database().reference()
        
        let group = DispatchGroup()
        var newChats: [Chat] = []
        
//        for chatId in user.chatIDs {
//            group.enter()
//            print("chatID: \(chatId)")
//            self.ref.child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
//                let value = snapshot.value as? NSDictionary
//
//                var chat: Chat = Chat(chatNum: "", senderId: "", recipientId: "")
//
//                let chatNum = value?["chatNum"] as? String ?? ""
//                let senderId = value?["senderId"] as? String ?? ""
//                let recipientId = value?["recipientId"] as? String ?? ""
//
//                print("info: \(chatNum) \(senderId) \(recipientId)")
//
//                chat.chatNum = chatNum
//                chat.senderId = senderId
//                chat.recipientId = recipientId
//
//                newChats.append(chat)
//                group.leave()
//            })
//        }
//        group.notify(queue: .main) {
//            self.chats = newChats
//            self.tableView.reloadData()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tabBarController?.tabBar.isHidden = false
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
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath) as! ChatTableViewCell

        // Configure the cell...
        if user.email == chats[indexPath.row].recipientId {
            cell.nameLabel.text = chats[indexPath.row].senderId
        }
        else {
            cell.nameLabel.text = chats[indexPath.row].recipientId
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chatSegue" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let chatViewController = segue.destination as! ChatViewController
                chatViewController.chat = chats[indexPath.row]
                chatViewController.user = self.user
            }
        }
    }
}
