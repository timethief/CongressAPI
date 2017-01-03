//
//  LegislHouseTableViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/28/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class LegisHouseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet weak var leftMenuButtonItem: UIBarButtonItem!
    @IBOutlet weak var LegisHouseTableView: UITableView!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    
    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Legislator] = [Legislator]()
    var filteredArray: [Legislator] = [Legislator]()
    var cancelItem: UIBarButtonItem?
    var searchItem2: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(LegisHouseTableViewController.searchHouse(_:)))
        
        initButton()
        configureSearchBar()
        
        getData()
        
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("fetching data...")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func initButton() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.leftMenuButtonItem.setTitleTextAttributes(attributes, for: .normal)
        self.leftMenuButtonItem.title = String.fontAwesomeIcon(name: .bars)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.LegisHouseTableView.reloadData()
        }
    }
    
    func getData() {
        let legislatorUrl = URL(string: "http://lowcost-env.5eg7x3kqgk.us-west-1.elasticbeanstalk.com/myweb.php?type=legisHouse")
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
                        self.dataArray.append(tmp)
                    }
                }
                //self.dataArray = self.dataArray.filter({$0.chamber == "house"})
                self.dataArray = self.dataArray.sorted(by: {$0.lastName < $1.lastName})
                sleep(5)
                self.reloadInMain()
                SwiftSpinner.hide()
            }
        }
        task.resume()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.LegisHouseTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.LegisHouseTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.LegisHouseTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.LegisHouseTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.LegisHouseTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.firstName.lowercased().range(of: searchText.lowercased()) != nil})
            isSearched = true
            self.LegisHouseTableView.reloadData()
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func searchHouse(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.LegisHouseTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.LegisHouseTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearched {
            return filteredArray.count
        } else {
            return dataArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LegisHouseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LegisHouseCell
        // Configure the cell...
        var legislator : Legislator?
        if self.isSearched {
            legislator = filteredArray[indexPath.row]
        } else {
            legislator = dataArray[indexPath.row]
        }
        cell.legisHouseNameLable.text = legislator?.name
        cell.legisHouseStateLabel.text = legislator?.stateName
        cell.legisHousImage.image = legislator?.img
        if indexPath.row == dataArray.count - 1 {
            print("Last One")
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "houseShowDetail" {
            let legislatorDetailVC = segue.destination as! ViewController
            if let selectedLegislatorCell = sender as? LegisHouseCell {
                let indexPath = self.LegisHouseTableView.indexPath(for: selectedLegislatorCell)!
                if self.isSearched {
                    legislatorDetailVC.legislator = filteredArray[indexPath.row]
                } else {
                    legislatorDetailVC.legislator = dataArray[indexPath.row]
                }
                legislatorDetailVC.from = "house"
                //legislatorDetailVC.hidesBottomBarWhenPushed = true
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }

    

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
