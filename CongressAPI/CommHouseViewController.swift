//
//  CommHouseViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/30/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class CommHouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // MARK: Properties
    @IBOutlet weak var leftMenuItem: UIBarButtonItem!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    @IBOutlet weak var commTable: UITableView!
    
    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Committee] = [Committee]()
    var filteredArray: [Committee] = [Committee]()
    var cancelItem: UIBarButtonItem?
    var searchItem2: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        initButton()
        getData()
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("fetching data...")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButton() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.leftMenuItem.setTitleTextAttributes(attributes, for: .normal)
        self.leftMenuItem.title = String.fontAwesomeIcon(name: .bars)
        
        cancelItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CommHouseViewController.searchComm(_:)))
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.commTable.reloadData()
        }
    }
    
    func getData() {
        let billUrl = URL(string: "http://lowcost-env.5eg7x3kqgk.us-west-1.elasticbeanstalk.com/myweb.php?type=commHouse")
        var request = URLRequest(url: billUrl!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data is empty")
                return
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print("Get Committee data")
            if let dict = json as? [String: Any] {
                if let array = dict["results"] as? [Any] {
                    for object in array {
                        let tmp = Committee(record: object)
                        self.dataArray.append(tmp)
                    }
                }
                //self.dataArray = self.dataArray.filter({$0.chamber == "house"})
                self.dataArray = self.dataArray.sorted(by: {$0.name < $1.name})
                self.reloadInMain()
                SwiftSpinner.hide()
            }
        }
        task.resume()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.commTable.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTable.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.commTable.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.name.range(of: searchText) != nil
                || $0.name.lowercased().range(of: searchText) != nil})
            isSearched = true
            self.commTable.reloadData()
        }
    }

    
    // MARK: Actions
    
    @IBAction func lleftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func searchComm(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.commTable.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.commTable.reloadData()
        }
    }
    
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
        
        let cellIdentifier = "CommHouseTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommHouseTableViewCell
        // Configure the cell...
        var comm : Committee?
        if self.isSearched {
            comm = filteredArray[indexPath.row]
        } else {
            comm = dataArray[indexPath.row]
        }
        cell.commLabel.text = comm?.name
        cell.commIdLabel.text = comm?.id
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommHouseShowDetail" {
            let commDetailVC = segue.destination as! CommDetailViewController
            if let selectedCommCell = sender as? CommHouseTableViewCell {
                let indexPath = self.commTable.indexPath(for: selectedCommCell)!
                if self.isSearched {
                    commDetailVC.committee = filteredArray[indexPath.row]
                } else {
                    commDetailVC.committee = dataArray[indexPath.row]
                }
                self.tabBarController?.tabBar.isHidden = true
            }
        }
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
