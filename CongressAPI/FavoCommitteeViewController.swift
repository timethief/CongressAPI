//
//  FavoCommitteeViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 12/1/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class FavoCommitteeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var leftMenuItem: UIBarButtonItem!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    @IBOutlet weak var commTableView: UITableView!

    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Committee] = [Committee]()
    var filteredArray: [Committee] = [Committee]()
    var cancelItem: UIBarButtonItem?
    var searchItem2: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("fetching data...")
        configureSearchBar()
        initButton()
        getData()
        
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
        
        cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FavoCommitteeViewController.searchCommittee(_:)))
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.commTableView.reloadData()
        }
    }
    
    func getData() {
        self.dataArray = CommDetailViewController.favoCommittees
        self.dataArray = self.dataArray.sorted(by: {$0.name < $1.name})
        self.reloadInMain()
        SwiftSpinner.hide()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.commTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.commTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.commTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.name.range(of: searchText) != nil
                || $0.name.lowercased().range(of: searchText) != nil})
            isSearched = true
            self.commTableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func searchCommittee(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.commTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.commTableView.reloadData()
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
        
        let cellIdentifier = "FavoCommTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoCommTableViewCell
        // Configure the cell...
        var comm : Committee?
        if self.isSearched {
            comm = filteredArray[indexPath.row]
        } else {
            comm = dataArray[indexPath.row]
        }
        cell.titleLabel.text = comm?.name
        cell.idLabel.text = comm?.id
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoCommittee" {
            let commDetailVC = segue.destination as! CommDetailViewController
            if let selectedCommCell = sender as? FavoCommTableViewCell {
                let indexPath = self.commTableView.indexPath(for: selectedCommCell)!
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
