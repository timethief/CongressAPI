//
//  CommDetailViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class CommDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet weak var favoItem: UIBarButtonItem!
    @IBOutlet weak var commTable: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var committee : Committee? = nil
    static var favoCommittees: [Committee] = [Committee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonInit()
        self.textView.text = self.committee?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonInit() {
        let favorited = inFavoriteList()
        if favorited {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoItem.tintColor = UIColor.blue
            self.favoItem.title = String.fontAwesomeIcon(name: .star)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoItem.title = String.fontAwesomeIcon(name: .starO)
        }
    }
    
    
    func inFavoriteList() -> Bool {
        if CommDetailViewController.favoCommittees.filter({$0.id == self.committee?.id}).count > 0 {
            return true
        } else {
            return false
        }
    }

    
    // MARK: Actions
    
    @IBAction func backComm(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        if let vc = self.navigationController?.topViewController as? FavoCommitteeViewController {
            if inFavoriteList() == false {
                vc.dataArray = vc.dataArray.filter({$0.id != committee?.id})
                vc.commTableView.reloadData()
            }
        }

    }
    
    @IBAction func favoAction(_ sender: UIBarButtonItem) {
        let favorited = inFavoriteList()
        if favorited == false {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoItem.tintColor = UIColor.blue
            self.favoItem.title = String.fontAwesomeIcon(name: .star)
            CommDetailViewController.favoCommittees.append(self.committee!)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoItem.title = String.fontAwesomeIcon(name: .starO)
            CommDetailViewController.favoCommittees = CommDetailViewController.favoCommittees.filter({$0.id != self.committee?.id})
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommDetailTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.commLeftLabel.text = "ID"
            cell.commRightLabel.text = committee?.id
        case 1:
            cell.commLeftLabel.text = "Parent ID"
            if committee?.parentID == "" {
                cell.commRightLabel.text = "N.A"
            } else {
                cell.commRightLabel.text = committee?.parentID
            }
        case 2:
            cell.commLeftLabel.text = "Chamber"
            cell.commRightLabel.text = committee?.chamber
        case 3:
            cell.commLeftLabel.text = "Office"
            if committee?.office == "" {
                cell.commRightLabel.text = "N.A"
            } else {
                cell.commRightLabel.text = committee?.office
            }
        case 4:
            cell.commLeftLabel.text = "Contact"
            if committee?.contact == "" {
                cell.commRightLabel.text = "N.A"
            } else {
                cell.commRightLabel.text = committee?.contact
            }
        default:
            break
        }
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
