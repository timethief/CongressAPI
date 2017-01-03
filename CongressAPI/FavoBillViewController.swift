//
//  FavoBillViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 12/1/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class FavoBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var leftMenuItem: UIBarButtonItem!
    @IBOutlet weak var searchItem: UIBarButtonItem!
   
    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Bill] = [Bill]()
    var filteredArray: [Bill] = [Bill]()
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
        
        cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FavoBillViewController.searchBills(_:)))
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    func reloadInMain() {
        DispatchQueue.main.async {
            self.billTableView.reloadData()
        }
    }
    
    func getData() {
        self.dataArray = BillDetailViewController.favoBills
        self.dataArray = self.dataArray.sorted(by: {Int($0.introducedon.timeIntervalSince1970) > Int($1.introducedon.timeIntervalSince1970)})
        self.reloadInMain()
        SwiftSpinner.hide()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.billTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.billTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.billTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.billTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.billTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.officialTitle.range(of: searchText) != nil
                || $0.officialTitle.lowercased().range(of: searchText.lowercased()) != nil})
            isSearched = true
            self.billTableView.reloadData()
        }
    }


    // MARK: Actions
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func searchBills(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.billTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.billTableView.reloadData()
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
        
        let cellIdentifier = "FavoBillTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoBillTableViewCell
        // Configure the cell...
        var bill : Bill?
        if self.isSearched {
            bill = filteredArray[indexPath.row]
        } else {
            bill = dataArray[indexPath.row]
        }
        cell.titleLabel.text = bill?.officialTitle
        cell.billID.text = bill?.billID
        cell.billDate.text = bill?.introducedStr
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoBill" {
            let billDetailVC = segue.destination as! BillDetailViewController
            if let selectedCommCell = sender as? FavoBillTableViewCell {
                let indexPath = self.billTableView.indexPath(for: selectedCommCell)!
                if self.isSearched {
                    billDetailVC.bill = filteredArray[indexPath.row]
                } else {
                    billDetailVC.bill = dataArray[indexPath.row]
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
