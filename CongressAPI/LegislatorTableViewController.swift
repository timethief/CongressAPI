//
//  LegislatorTableViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/25/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SlideMenuControllerSwift
import FontAwesome_swift


class LegislatorTableViewController: UITableViewController{
    
    // MARK: Properties
    @IBOutlet weak var leftSideMenu: UIBarButtonItem!
    
    
    let arrIndexSection = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                           "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var sectionArr = [String]()
    var legislatorArray = [[Legislator]]()
    var sectionTitle = [String]()
    var legislators = [[Legislator]]()
    var selectedState: String = "All states"
    var legisTabBarController: UITabBarController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Legislator Load!!!")
        loadLegislators()
        initButton()
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("fetching data...")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        legisTabBarController = self.tabBarController!
    }
    
    func initButton() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.leftSideMenu.setTitleTextAttributes(attributes, for: .normal)
        self.leftSideMenu.title = String.fontAwesomeIcon(name: .bars)
    }
    
    func loadLegislators() {
        for _ in self.arrIndexSection {
            self.legislators.append([])
        }
        print("Begin to Load Legislators")
        if legislators.count > 0 {
            let legislatorUrl = URL(string: "http://lowcost-env.5eg7x3kqgk.us-west-1.elasticbeanstalk.com/myweb.php?type=legislators")
            var request = URLRequest(url: legislatorUrl!)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                print("Get Legislator data")
                if let dict = json as? [String: Any] {
                    if let array = dict["results"] as? [Any] {
                        for object in array {
                            let tmp = Legislator(record: object)
                            let fs =  String(describing: tmp.stateName.characters.first!)
                            var index = 0
                            for c in self.arrIndexSection {
                                if fs == String(describing:c) {
                                    break
                                }
                                index = index + 1
                            }
                            if self.legislators[index].count > 0 {
                                self.legislators[index] += [tmp]
                            } else {
                                self.legislators[index] = [tmp]
                            }
                        }
                    }
                    print("translate data")
                    var num = 0
                    for arr in self.legislators {
                        if arr.count > 0 {
                            self.sectionArr.append(self.arrIndexSection[num])
                            self.legislatorArray.append(arr)
                        }
                        num = num + 1
                    }
                    self.legislators = []
                    for group in self.legislatorArray {
                         self.legislators.append(group.sorted(by: {$0.lastName < $1.lastName}))
                    }
                    self.legislatorArray = self.legislators
                    self.sectionTitle = self.sectionArr
                    self.updateTable()
                }
            }
            task.resume()
        }
    }
    
    func updateTable() {
        sleep(10)
        self.tableView.reloadData()
        SwiftSpinner.hide()
    }
    
    func fileterByState() {
        if self.selectedState == "All states" {
            self.sectionArr = self.sectionTitle
            self.legislatorArray = self.legislators
        } else {
            let s = String(describing: self.selectedState.characters.first!)
            let index = self.sectionTitle.index(of: s)
            self.sectionArr = []
            self.sectionArr.append(s)
            self.legislatorArray = []
            self.legislatorArray.append(self.legislators[index!].filter({$0.stateName == selectedState}))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func LeftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func stateFilter(_ sender: UIBarButtonItem) {
        //let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "StatePickerViewController") as! StatePickerViewController
        //self.navigationController?.pushViewController(filterVC, animated: false)
    }
    
    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLegislatorDetail" {
            let legislatorDetailVC = segue.destination as! ViewController
            if let selectedLegislatorCell = sender as? LegislatorTableViewCell {
                let indexPath = self.tableView.indexPath(for: selectedLegislatorCell)!
                let selectedLegislator = self.legislatorArray[indexPath.section][indexPath.row]
                legislatorDetailVC.legislator = selectedLegislator
                legislatorDetailVC.from = "state"
                //legislatorDetailVC.hidesBottomBarWhenPushed = true
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.legislatorArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.legislatorArray[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LegislatorTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LegislatorTableViewCell
        // Configure the cell...
        let legislator = self.legislatorArray[indexPath.section][indexPath.row]
        cell.nameLabel.text = legislator.name
        cell.stateLabel.text = legislator.stateName
        cell.protoImage.image = legislator.img
        return cell
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionArr
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.sectionArr.index(of: title)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print(section)
        return self.sectionArr[section]
    }

    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
