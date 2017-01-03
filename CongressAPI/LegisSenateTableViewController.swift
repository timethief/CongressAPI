//
//  LegisSenateTableViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/28/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner
import FontAwesome_swift

class LegisSenateTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    

    //MARK: propertities
    @IBOutlet weak var leftMenuButtonItem: UIBarButtonItem!
    @IBOutlet weak var legisSenateTableView: UITableView!
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

        cancelItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(LegisSenateTableViewController.searchSenate(_:)))

        
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
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.legisSenateTableView.reloadData()
        }
    }
    
    func getData() {
        let legislatorUrl = URL(string: "http://lowcost-env.5eg7x3kqgk.us-west-1.elasticbeanstalk.com/myweb.php?type=legisSenate")
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
                self.dataArray = self.dataArray.filter({$0.chamber == "senate"})
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
        self.legisSenateTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.legisSenateTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.legisSenateTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.legisSenateTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.legisSenateTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.firstName.lowercased().range(of: searchText.lowercased()) != nil})
            isSearched = true
            self.legisSenateTableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func searchSenate(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.legisSenateTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.legisSenateTableView.reloadData()
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
        
        let cellIdentifier = "LegisSenateCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LegisSenateCell
        // Configure the cell...
        var legislator : Legislator?
        if self.isSearched {
            legislator = filteredArray[indexPath.row]
        } else {
            legislator = dataArray[indexPath.row]
        }
        cell.legisSenateNameLabel.text = legislator?.name
        cell.legisSenateStateLabel.text = legislator?.stateName
        cell.legisSenateImage.image = legislator?.img
        if indexPath.row == dataArray.count - 1 {
            print("Last One")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "senateShowDetail" {
            let legislatorDetailVC = segue.destination as! ViewController
            if let selectedLegislatorCell = sender as? LegisSenateCell {
                let indexPath = self.legisSenateTableView.indexPath(for: selectedLegislatorCell)!
                if self.isSearched {
                    legislatorDetailVC.legislator = filteredArray[indexPath.row]
                } else {
                    legislatorDetailVC.legislator = dataArray[indexPath.row]
                }
                legislatorDetailVC.from = "senate"
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
