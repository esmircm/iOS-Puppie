//
//  EntryTableViewCell.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodControl: MoodControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
