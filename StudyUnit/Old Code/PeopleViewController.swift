//
//  PeopleViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController {

    @IBOutlet var textField: UITextView!
    
    var user: User!
    var recipientId: String!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.text = ""
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        // 'send' message using firebase, possibly start a chat if needed
        
        // get references
//        let userRef = ref.child(Helper.removeSpecialCharsFromString(text: user.email))
//        let recepientRef = ref.child(Helper.removeSpecialCharsFromString(text: recipientId))
//        
//        // create chatMsg
//        let chatMsgRef = ref.childByAutoId()
//        let message = ["sender_id": user.email, "name": user.name, "text": textField.text] as [String : Any]
//        chatMsgRef.setValue(message)
//        
//        // get the chatNum associated with this recepient if possible:
//        let group = DispatchGroup()
//        var chatNum: String = ""
//        
//        ref.child(Helper.removeSpecialCharsFromString(text: user.email)).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let usrValue = snapshot.value as? NSDictionary
//            let chatIDs = usrValue?["chatIDs"] as? NSDictionary
//            var uChatIDs: [String] = []
//            for (_, value) in chatIDs! {
//                uChatIDs.append(value as! String)
//            }
//            self.user.chatIDs = uChatIDs
//            
//            for chatId in self.user.chatIDs {
//                group.enter()
//                self.ref.child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
//                    let value = snapshot.value as? NSDictionary
//                    let cn = value?["chatNum"] as? String ?? ""
//                    let ri = value?["recipientId"] as? String ?? ""
//                    let si = value?["senderId"] as? String ?? ""
//                    
//                    print("ri: \(ri) si: \(si)")
//                    if ri == self.user.email || si == self.user.email {
//                        chatNum = cn
//                    }
//                    group.leave()
//                })
//            }
//            
//            group.notify(queue: .main) {
//                if chatNum != "" {
//                    // we have an existing chat, so just add to it:
//                    let addChatRef = self.ref.child(chatNum).childByAutoId()
//                    addChatRef.setValue(chatMsgRef.key)
//                    print("existing chat ayyy")
//                }
//                else {
//                    // otherwise, make it all new:
//                    
//                    // add chatMsg to new chatNum
//                    let chatNumRef = self.ref.childByAutoId()
//                    let chatIdRef = chatNumRef.childByAutoId()
//                    chatIdRef.setValue(chatMsgRef.key)
//                    
//                    // add chatNum to new chatMetaData
//                    let chatMetaRef = self.ref.childByAutoId()
//                    let meta = ["chatNum":chatNumRef.key,
//                                "senderId":self.user.email,
//                                "recipientId":self.recipientId]
//                    chatMetaRef.setValue(meta)
//                    
//                    // add metaId to both users
//                    let newUserChatIdRef = userRef.child("chatIDs").childByAutoId()
//                    newUserChatIdRef.setValue(chatMetaRef.key)
//                    
//                    let newRecepientChatIdRef = recepientRef.child("chatIDs").childByAutoId()
//                    newRecepientChatIdRef.setValue(chatMetaRef.key)
//                }
//                
//                // delete nil
//                userRef.child("chatIDs").child("nil").removeValue()
//                recepientRef.child("chatIDs").child("nil").removeValue()
//            }
//        })

    }
}
