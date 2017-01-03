//
//  Committee.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class Committee {
    var name: String = ""
    var id: String = ""
    var parentID: String  = ""
    var chamber: String = ""
    var office: String = ""
    var contact: String = ""
    
    
    init(record: Any) {
        if let dictionary = record as? [String: Any] {
            if let Name = dictionary["name"] as? String {
                name = Name
            }
            if let ID = dictionary["committee_id"] as? String {
                id = ID
            }
            if let ParentID = dictionary["parent_committee_id"] as? String {
                parentID = ParentID
            }
            if let Chamber = dictionary["chamber"]  as? String{
                chamber = Chamber
            }
            if let Office = dictionary["office"] as? String {
                office = Office
            }
            if let Contact = dictionary["phone"] as? String {
                contact = Contact
            }
        }
    }
}
