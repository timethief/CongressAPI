//
//  BillDetailViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Propertities
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoButtonItem: UIBarButtonItem!
    @IBOutlet weak var billTitleTextView: UITextView!
    
    var bill : Bill? = nil
    static var favoBills: [Bill] = [Bill]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonInit()
        self.billTitleTextView.text = self.bill?.officialTitle
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
            self.favoButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoButtonItem.tintColor = UIColor.blue
            self.favoButtonItem.title = String.fontAwesomeIcon(name: .star)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoButtonItem.title = String.fontAwesomeIcon(name: .starO)
        }
    }
    

    func inFavoriteList() -> Bool {
        if BillDetailViewController.favoBills.filter({$0.billID == self.bill?.billID}).count > 0 {
            return true
        } else {
            return false
        }
    }

    
    // MARK: Actions
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        if let vc = self.navigationController?.topViewController as? FavoBillViewController {
            if inFavoriteList() == false {
                vc.dataArray = vc.dataArray.filter({$0.billID != bill?.billID})
                vc.billTableView.reloadData()
            }
        }

    }
    
    @IBAction func favoAction(_ sender: UIBarButtonItem) {
        let favorited = inFavoriteList()
        if favorited == false {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoButtonItem.tintColor = UIColor.blue
            self.favoButtonItem.title = String.fontAwesomeIcon(name: .star)
            BillDetailViewController.favoBills.append(self.bill!)
        } else {
            let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
            self.favoButtonItem.setTitleTextAttributes(attributes, for: .normal)
            self.favoButtonItem.title = String.fontAwesomeIcon(name: .starO)
            BillDetailViewController.favoBills = BillDetailViewController.favoBills.filter({$0.billID != self.bill?.billID})
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            UIApplication.shared.open(URL(string: (bill?.pdfLink)!)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BillDetailViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BillDetailViewCell
        switch indexPath.row {
        case 0:
            cell.billLeftLabel.text = "Bill ID"
            cell.billRightLabel.text = bill?.billID
        case 1:
            cell.billLeftLabel.text = "BIll Type"
            cell.billRightLabel.text = bill?.billType
        case 2:
            cell.billLeftLabel.text = "Sponsor"
            cell.billRightLabel.text = bill?.sponsor
        case 3:
            cell.billLeftLabel.text = "Last Action"
            if bill?.introducedStr == "" {
                cell.billRightLabel.text = "N.A"
            } else {
                cell.billRightLabel.text = bill?.lastActionStr
            }
        case 4:
            cell.billLeftLabel.text = "PDF"
            if bill?.pdfLink == "" {
                cell.billRightLabel.text = "N.A"
            } else {
                cell.billRightLabel.textColor = UIColor.blue
                cell.billRightLabel.text = "PDF LINK"
            }
        case 5:
            cell.billLeftLabel.text = "Chamber"
            cell.billRightLabel.text = bill?.chamber
        case 6:
            cell.billLeftLabel.text = "Last Vote"
            if bill?.lastVoteStr == "" {
                cell.billRightLabel.text = "N.A"
            } else {
                cell.billRightLabel.text = bill?.lastVoteStr
            }
        case 7:
            cell.billLeftLabel.text = "Status"
            cell.billRightLabel.text = bill?.status
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
