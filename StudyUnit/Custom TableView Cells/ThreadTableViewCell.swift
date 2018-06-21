//
//  ThreadTableViewCell.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/21/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var numRepliesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
