//
//  CommitteeTableViewCell.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class CommHouseTableViewCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var commLabel: UILabel!
    @IBOutlet weak var commIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class CommSenateTableViewCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var commLabel: UILabel!
    @IBOutlet weak var commIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class CommJointTableViewCell: UITableViewCell {
     // MARK: Propertities
    @IBOutlet weak var commLabel: UILabel!
    
    @IBOutlet weak var commIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class CommDetailTableViewCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var commLeftLabel: UILabel!
    @IBOutlet weak var commRightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

