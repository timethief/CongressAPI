//
//  ViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/25/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import FontAwesome_swift


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var legislator : Legislator? = nil
    var lastCall : String = "Legislator"
    var from: String = "state"
    static var favoLegislators: [Legislator] = [Legislator]()
    
    // MARK: properties
    @IBOutlet weak var favoriteButtonItem: UIBarButtonItem!
    @IBOutlet weak var LegislatorImgae: UIImageView!
    @IBOutlet weak var LegislatorDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LegislatorDetailTableView.delegate = self
        LegislatorDetailTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        buttonInit()
        dataInit()
    }

    func buttonInit() {
        let favorited = inFavoriteList()
        if favorited {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoriteButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoriteButtonItem.tintColor = UIColor.blue
            self.favoriteButtonItem.title = String.fontAwesomeIcon(name: .star)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoriteButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoriteButtonItem.title = String.fontAwesomeIcon(name: .starO)
        }
    }
    
    func dataInit() {
        LegislatorImgae.image = legislator?.img
    }
    
    func inFavoriteList() -> Bool {
        if ViewController.favoLegislators.filter({$0.name == self.legislator?.name}).count > 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Actions
    @IBAction func favoriteActions(_ sender: UIBarButtonItem) {
        let favorited = inFavoriteList()
        if favorited == false {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoriteButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoriteButtonItem.tintColor = UIColor.blue
            self.favoriteButtonItem.title = String.fontAwesomeIcon(name: .star)
            ViewController.favoLegislators.append(self.legislator!)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoriteButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoriteButtonItem.title = String.fontAwesomeIcon(name: .starO)
            ViewController.favoLegislators = ViewController.favoLegislators.filter({$0.name != self.legislator?.name})
        }
    }
    
    @IBAction func legislatorBackAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        if let vc = self.navigationController?.topViewController as? FavoLegislatorViewController {
            if inFavoriteList() == false {
                vc.dataArray = vc.dataArray.filter({$0.name != legislator?.name})
                vc.legislatorTableView.reloadData()
            }
        }
        
        //dismiss(animated: true, completion: nil)
        /*var legislatorVC: UIViewController?
        if self.from == "state" {
             legislatorVC = self.storyboard?.instantiateViewController(withIdentifier: "LegislatorTableViewController") as! LegislatorTableViewController
        } else if self.from == "house" {
            legislatorVC = self.storyboard?.instantiateViewController(withIdentifier: "LegisHouseTableViewController") as! LegisHouseTableViewController
        } else if self.from == "senate" {
            legislatorVC = self.storyboard?.instantiateViewController(withIdentifier: "LegisSenateTableViewController") as! LegisSenateTableViewController
        }
        
        self.navigationController?.pushViewController(legislatorVC!, animated: true)
        self.tabBarController?.tabBar.isHidden = false*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7, legislator?.twitterLink != "" {
            UIApplication.shared.open(URL(string: (legislator?.twitterLink)!)!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 8, legislator?.webLink != "" {
            UIApplication.shared.open(URL(string: (legislator?.webLink)!)!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 9, legislator?.facebookLink != "" {
            UIApplication.shared.open(URL(string: (legislator?.facebookLink)!)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LegislatorDetailTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LegislatorDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.leftColoum.text = "First Name"
            cell.rightColoum.text = legislator?.firstName
        case 1:
            cell.leftColoum.text = "Last Name"
            cell.rightColoum.text = legislator?.lastName
        case 2:
            cell.leftColoum.text = "State"
            cell.rightColoum.text = legislator?.stateName
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            cell.leftColoum.text = "Birth date"
            cell.rightColoum.text = dateFormatter.string(from: (legislator?.birthDate)!)
        case 4:
            cell.leftColoum.text = "Gender"
            if legislator?.gender == "F" {
                cell.rightColoum.text = "Female"
            } else {
                cell.rightColoum.text = "Male"
            }
        case 5:
            cell.leftColoum.text = "Chamber"
            cell.rightColoum.text = legislator?.chamber
        case 6:
            cell.leftColoum.text = "Fax No."
            if legislator?.faxNo == "" {
                cell.rightColoum.text = "N.A"
            } else {
                cell.rightColoum.text = legislator?.faxNo
            }
        case 7:
            cell.leftColoum.text = "Twitter"
            if legislator?.twitterLink == "" {
                cell.rightColoum.text = "N.A"
            } else {
                cell.rightColoum.textColor = UIColor.blue
                cell.rightColoum.text = "Twitter Link"
            }
        case 8:
            cell.leftColoum.text = "Website"
            if legislator?.webLink == "" {
                cell.rightColoum.text = "N.A"
            } else {
                cell.rightColoum.textColor = UIColor.blue
                cell.rightColoum.text = "Website Link"
            }
        case 9:
            cell.leftColoum.text = "Facebook"
            if legislator?.facebookLink == "" {
                cell.rightColoum.text = "N.A"
            } else {
                cell.rightColoum.textColor = UIColor.blue
                cell.rightColoum.text = "Facebook Link"
            }
        case 10:
            cell.leftColoum.text = "Office No."
            cell.rightColoum.text = legislator?.officeNo
        case 11:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            cell.leftColoum.text = "Term ends on"
            cell.rightColoum.text = dateFormatter.string(from: (legislator?.termEnd)!)
        default:
            break
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

