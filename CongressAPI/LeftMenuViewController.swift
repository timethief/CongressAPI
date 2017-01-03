//
//  LeftMenuViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/26/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let menus: [String] = ["Legislators", "Bills", "Committee", "Favorite", "About"]
    
    // MARK: Properties
    
    @IBOutlet weak var leftMenuTableView: UITableView!
    @IBOutlet weak var congressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leftMenuTableView.delegate = self
        leftMenuTableView.dataSource = self
        
        self.congressLabel.text = "Congress API"
        congressLabel.font = congressLabel.font.withSize(40)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LeftMenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LeftMenuTableViewCell
        cell.leftMenuLabel.text = self.menus[indexPath.row]
        print(self.menus[indexPath.row])
        return cell
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 0 {
            let legisTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "LegisTabBarController")
            self.slideMenuController()?.changeMainViewController(legisTabBarController!, close: false)
            self.slideMenuController()?.closeLeft()
        } else if row == 1 {
            let billTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "BillTabBarController")
            self.slideMenuController()?.changeMainViewController(billTabBarController!, close: false)
            self.slideMenuController()?.closeLeft()
        } else if row == 2 {
            let commTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CommTabBarController")
            self.slideMenuController()?.changeMainViewController(commTabBarController!, close: false)
            self.slideMenuController()?.closeLeft()
        } else if row == 3 {
            let favoTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "FavoTabBarController")
            self.slideMenuController()?.changeMainViewController(favoTabBarController!, close: false)
            self.slideMenuController()?.closeLeft()
        } else if row == 4 {
            let aboutTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "AboutNavigationController")
            self.slideMenuController()?.changeMainViewController(aboutTabBarController!, close: false)
            self.slideMenuController()?.closeLeft()
        }
        return
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
