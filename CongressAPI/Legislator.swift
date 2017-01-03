//
//  Legislator.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/25/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class Legislator {
    // MARK: Properties
    
    var name: String = ""
    var stateName: String = ""
    var imgLink: String  = ""
    var img: UIImage = UIImage()
    var firstName: String = ""
    var lastName: String = ""
    var birthDate: Date = Date()
    var gender: String = ""
    var chamber: String = ""
    var faxNo: String? = ""
    var twitterLink: String? = ""
    var facebookLink: String? = ""
    var webLink: String? = ""
    var officeNo: String? = ""
    var termEnd: Date = Date()
    static var initNum: Int = 0
    static var curNum:Int = 0
    // MARK: Initialization
    
    init(record: Any) {
        if let dictionary = record as? [String: Any] {
            if let LastName = dictionary["last_name"] as? String {
                lastName = LastName
                name += lastName
            }
            if let FirstName = dictionary["first_name"] as? String {
                firstName = FirstName
                name += "，"
                name += firstName
            }
            if let StateName = dictionary["state_name"] as? String {
                stateName = StateName
            }
            if let ImgLink = dictionary["bioguide_id"] as? String {
                imgLink = "https://theunitedstates.io/images/congress/225x275/" + ImgLink + ".jpg"
                if Legislator.curNum < Legislator.initNum {
                    let url = URL(string: imgLink)
                    if let data = try? Data(contentsOf: url!) {
                        self.img = UIImage(data: data)!
                    }
                } else {
                    //DispatchQueue.main.async {
                    DispatchQueue.global().async {
                        let url = URL(string: self.imgLink)
                        if let data = try? Data(contentsOf: url!) {
                            self.img = UIImage(data: data)!
                        }
                    }
                }
            }
            if let BirthDate = dictionary["birthday"] as? String {
                if BirthDate != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    birthDate = dateFormatter.date(from: BirthDate)!
                }
            }
            if let Gender = dictionary["gender"] as? String {
                gender = Gender
            }
            if let Chamber = dictionary["chamber"] as? String {
                chamber = Chamber
            }
            if let FaxNo = dictionary["fax"] as? String {
                faxNo = FaxNo
            }
            if let TwitterLink = dictionary["twitter_id"] as? String {
                twitterLink = "https://twitter.com/" + TwitterLink
            }
            if let FacebookLink = dictionary["facebook_id"] as? String {
                facebookLink = "https://facebook.com/" + FacebookLink
            }
            if let WebLink = dictionary["website"] as? String {
                webLink = WebLink
            }
            if let OfficeNo = dictionary["office"] as? String {
                officeNo = OfficeNo
            }
            if let TermEnd = dictionary["term_end"] as? String {
                if TermEnd != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    termEnd = dateFormatter.date(from: TermEnd)!
                }
            }
            Legislator.curNum = Legislator.curNum + 1
        }
    }
}
