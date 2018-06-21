//
//  ChatViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    var ref: DatabaseReference!
    
    var user: User!
    var chat: Chat!

    var messages = [JSQMessage]()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        ref = Database.database().reference()
        senderId = user.email
        senderDisplayName = user.name

        // Do any additional setup after loading the view.
        
        if user.email == chat.recipientId {
            title = "Chat: \(chat.senderId)"
        }
        else {
            title = "Chat: \(chat.recipientId)"
        }
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let query = ref.child(chat.chatNum)
        print("querying from: \(chat.chatNum)")
        query.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let group = DispatchGroup()
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                group.enter()
                
                let chatId = rest.value as! String
                print("chat id is: \(chatId)")
                self.ref.child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let id = value?["sender_id"] as? String ?? ""
                    let name = value?["name"] as? String ?? ""
                    let text = value?["text"] as? String ?? ""
                    print("values are \(id) \(name) \(text)")
                    if let message = JSQMessage(senderId: id, displayName: name, text: text)
                    {
                        print("added msg \(message)")
                        self.messages.append(message)
                        
                        self.finishReceivingMessage()
                    }
                    
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                self.collectionView?.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        // generate unique id for chat msg
        let sendRef = ref.childByAutoId()
        
        // add to chatNum chatId dict
        let chatRef = ref.child(chat.chatNum).childByAutoId()
        chatRef.setValue(sendRef.key)
        
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        
        sendRef.setValue(message)
        
        let jsqMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.messages.append(jsqMessage!)
        
        finishSendingMessage()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
