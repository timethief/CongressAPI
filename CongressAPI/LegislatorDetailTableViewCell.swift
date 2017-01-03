//
//  LegislatorDetailCellTableViewCell.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/28/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class LegislatorDetailTableViewCell: UITableViewCell {
    
    // MARK: properties
    @IBOutlet weak var leftColoum: UILabel!
    @IBOutlet weak var rightColoum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
