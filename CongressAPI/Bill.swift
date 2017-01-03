//
//  Bill.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/29/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class Bill {
    var billID: String = ""
    var billType: String = ""
    var sponsor: String  = ""
    var lastAction: Date = Date()
    var lastActionStr: String = ""
    var pdfLink: String = ""
    var chamber: String = ""
    var lastVote: Date = Date()
    var lastVoteStr: String = ""
    var status: String = ""
    var officialTitle: String = ""
    var introducedon: Date = Date()
    var introducedStr: String = ""
    
    init(record: Any) {
        if let dictionary = record as? [String: Any] {
            if let BillID = dictionary["bill_id"] as? String {
                billID = BillID
            }
            if let BillType = dictionary["bill_type"] as? String {
                billType = BillType
            }
            if let Sponsor = dictionary["sponsor"] as? [String: Any] {
                if let title = Sponsor["title"] as? String, let firstName = Sponsor["first_name"] as? String,
                    let lastName = Sponsor["last_name"] as? String {
                    sponsor = title + " " + firstName + " " + lastName
                }
            }
            if var activeAt = dictionary["last_action_at"]  as? String{
                if activeAt != "" {
                    let endIndex = activeAt.index(activeAt.startIndex, offsetBy: 10)
                    activeAt = activeAt.substring(to: endIndex)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    lastAction = dateFormatter.date(from: activeAt)!
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    lastActionStr = dateFormatter.string(from: lastAction)
                }
            }
            if let history = dictionary["history"] as? [String: Any] {
                
                if let Status = history["active"] as? Bool {
                    if Status == true {
                        status = "Active"
                    } else {
                        status = "New"
                    }
                }
            }
            if let lastVersion = dictionary["last_version"] as? [String: Any] {
                if let urls = lastVersion["urls"] as? [String: Any] {
                    if let PdfLink = urls["pdf"] as? String {
                        pdfLink = PdfLink
                    }
                }
            }
            if let Chamber = dictionary["chamber"] as? String {
                chamber = Chamber
            }
            if var LastVote = dictionary["last_vote_at"] as? String {
                if LastVote != "" {
                    let endIndex = LastVote.index(LastVote.startIndex, offsetBy: 10)
                    LastVote = LastVote.substring(to: endIndex)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    lastVote = dateFormatter.date(from: LastVote)!
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    lastVoteStr = dateFormatter.string(from: lastVote)
                }
            }
            if let OfficalTitle = dictionary["official_title"] as? String {
                officialTitle = OfficalTitle
            }
            if var Introducedon = dictionary["introduced_on"] as? String {
                if Introducedon != "" {
                    let endIndex = Introducedon.index(Introducedon.startIndex, offsetBy: 10)
                    Introducedon = Introducedon.substring(to: endIndex)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    introducedon = dateFormatter.date(from: Introducedon)!
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    introducedStr = dateFormatter.string(from: introducedon)
                }
            }
        }
    }
}
