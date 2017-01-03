//
//  FavoLegislatorViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 12/1/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class FavoLegislatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // MARK: Propertities
    @IBOutlet weak var searchItem: UIBarButtonItem!
    @IBOutlet weak var leftMenu: UIBarButtonItem!
    @IBOutlet weak var legislatorTableView: UITableView!
    
    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Legislator] = [Legislator]()
    var filteredArray: [Legislator] = [Legislator]()
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
        self.leftMenu.setTitleTextAttributes(attributes, for: .normal)
        self.leftMenu.title = String.fontAwesomeIcon(name: .bars)
        
        cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FavoLegislatorViewController.searchLegislator(_:)))
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.legislatorTableView.reloadData()
        }
    }
    
    func getData() {
        self.dataArray = ViewController.favoLegislators
        self.dataArray = self.dataArray.sorted(by: {$0.lastName < $1.lastName})
        self.reloadInMain()
        SwiftSpinner.hide()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.legislatorTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.legislatorTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.legislatorTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.legislatorTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.legislatorTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.name.range(of: searchText) != nil
                || $0.name.lowercased().range(of: searchText) != nil})
            isSearched = true
            self.legislatorTableView.reloadData()
        }
    }

    
    // MARK: Actions
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func searchLegislator(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.legislatorTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.legislatorTableView.reloadData()
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
        
        let cellIdentifier = "FavoLegisTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoLegisTableViewCell
        // Configure the cell...
        var legislator : Legislator?
        if self.isSearched {
            legislator = filteredArray[indexPath.row]
        } else {
            legislator = dataArray[indexPath.row]
        }
        cell.nameLabel.text = legislator?.name
        cell.stateLabel.text = legislator?.stateName
        cell.legiImageView.image = legislator?.img
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoLegislator" {
            let legisDetailVC = segue.destination as! ViewController
            if let selectedLegisCell = sender as? FavoLegisTableViewCell {
                let indexPath = self.legislatorTableView.indexPath(for: selectedLegisCell)!
                if self.isSearched {
                    legisDetailVC.legislator = filteredArray[indexPath.row]
                } else {
                    legisDetailVC.legislator = dataArray[indexPath.row]
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
