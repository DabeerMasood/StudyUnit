//
//  PostTableViewCell.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/21/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var userLabel: UILabel!
    @IBOutlet var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
