//
//  BillTableViewCell.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    // MARK: PROpertities
    @IBOutlet weak var billTitleLabel: UILabel!
    
    @IBOutlet weak var billID: UILabel!
    
    @IBOutlet weak var billDate: UILabel!
    
    override func awakeFromNib() {

        self.billTitleLabel.numberOfLines = 0
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class BillNewTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var billID: UILabel!
    
    @IBOutlet weak var billTitleLabel: UILabel!
    @IBOutlet weak var billDate: UILabel!
    
    override func awakeFromNib() {
        
        self.billTitleLabel.numberOfLines = 0
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class BillDetailViewCell: UITableViewCell {
    // MARK: Propertities
    @IBOutlet weak var billLeftLabel: UILabel!
    @IBOutlet weak var billRightLabel: UILabel!

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
