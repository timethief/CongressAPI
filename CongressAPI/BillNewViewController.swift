//
//  BillNewViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/29/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SwiftSpinner

class BillNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Propertities
    @IBOutlet weak var billSlideMenu: UIBarButtonItem!
    
    @IBOutlet weak var billNewSearchItem: UIBarButtonItem!
    @IBOutlet weak var billNewTableView: UITableView!
    
    var isSearched: Bool = false
    var inSearch: Bool = false
    var searchBar = UISearchBar()
    var dataArray: [Bill] = [Bill]()
    var filteredArray: [Bill] = [Bill]()
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
    
    func initButton() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.billSlideMenu.setTitleTextAttributes(attributes, for: .normal)
        self.billSlideMenu.title = String.fontAwesomeIcon(name: .bars)
        
        cancelItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(BillNewViewController.billNewSearch(_:)))
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
            self.billNewTableView.reloadData()
        }
    }
    
    func getData() {
        let billUrl = URL(string: "http://lowcost-env.5eg7x3kqgk.us-west-1.elasticbeanstalk.com/myweb.php?type=billsNew")
        var request = URLRequest(url: billUrl!)
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
                        let tmp = Bill(record: object)
                        self.dataArray.append(tmp)
                    }
                }
                print(self.dataArray.count)
                //self.dataArray = self.dataArray.filter({$0.pdfLink != ""})
                self.dataArray = self.dataArray.sorted(by: {Int($0.introducedon.timeIntervalSince1970) > Int($1.introducedon.timeIntervalSince1970)})
                self.reloadInMain()
                SwiftSpinner.hide()
            }
        }
        task.resume()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.billNewTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        self.billNewTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched = true
            self.billNewTableView.reloadData()
        }
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        self.billNewTableView.reloadData()
        //searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            isSearched = false
            self.billNewTableView.reloadData()
        } else {
            filteredArray = dataArray.filter({$0.officialTitle.range(of: searchText) != nil
                || $0.officialTitle.lowercased().range(of: searchText.lowercased()) != nil})
            isSearched = true
            self.billNewTableView.reloadData()
        }
    }
    

    
    // MARK: Actions
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
         self.slideMenuController()?.openLeft()
    }

    @IBAction func billNewSearch(_ sender: UIBarButtonItem) {
        if self.inSearch == false {
            searchBar.placeholder = ""
            self.navigationItem.titleView = searchBar
            self.searchItem2 = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = cancelItem
            self.inSearch = true
            self.isSearched = false
            self.billNewTableView.reloadData()
        } else {
            self.inSearch = false
            self.isSearched = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = searchItem2
            self.billNewTableView.reloadData()
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
        
        let cellIdentifier = "BillNewTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BillNewTableViewCell
        // Configure the cell...
        var bill : Bill?
        if self.isSearched {
            bill = filteredArray[indexPath.row]
        } else {
            bill = dataArray[indexPath.row]
        }
        cell.billTitleLabel.text = bill?.officialTitle
        cell.billID.text = bill?.billID
        cell.billDate.text = bill?.introducedStr
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billNewShowDetail" {
            let billDetailVC = segue.destination as! BillDetailViewController
            if let selectedBillCell = sender as? BillNewTableViewCell {
                let indexPath = self.billNewTableView.indexPath(for: selectedBillCell)!
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
