//
//  LegislatorTableViewCell.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/25/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class LegislatorTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var protoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLabel.font = nameLabel.font.withSize(20)
        // Configure the view for the selected state
    }

}

class LegisHouseCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var legisHousImage: UIImageView!
    @IBOutlet weak var legisHouseNameLable: UILabel!
    @IBOutlet weak var legisHouseStateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        legisHouseNameLable.font = legisHouseNameLable.font.withSize(20)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class LegisSenateCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var legisSenateImage: UIImageView!
    @IBOutlet weak var legisSenateNameLabel: UILabel!
    @IBOutlet weak var legisSenateStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        legisSenateNameLabel.font = legisSenateNameLabel.font.withSize(20)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
