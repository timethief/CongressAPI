//
//  StatePickerViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/27/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import FontAwesome_swift

class StatePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Properties
    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    
    var selectedState : String = "All states"
    
    let allStates : [String] = ["All states", "Alabama", "Alaska","American Samoa","Arizona","Arkansas",
                                "California","Colorado","Connecticut","Delaware","District of Columbia",
                                "Federated States of Micronesia","Florida","Georgia","Guam","Hawaii","Idaho",
                                "Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine",
                                "Marshall Islands","Maryland", "Massachusetts", "Michigan","Minnesota",
                                "Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire",
                                "New Jersey","New Mexico","New York","North Carolina","North Dakota",
                                "Northern Mariana Islands","Ohio","Oklahoma","Oregon","Palau","Pennsylvania",
                                "Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee",
                                "Texas","Utah","Vermont","Virgin Island","Virginia","Washington",
                                "West Virginia","Wisconsin","Wyoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonInit()
        // Do any additional setup after loading the view.
    }
    
    func buttonInit() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.leftMenuButton.setTitleTextAttributes(attributes, for: .normal)
        self.leftMenuButton.title = String.fontAwesomeIcon(name: .bars)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allStates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.allStates[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = self.allStates[row]
        
        //let legislatorVC = self.storyboard?.instantiateViewController(withIdentifier: "LegislatorTableViewController") as! LegislatorTableViewController
        self.navigationController?.popViewController(animated: true)
        let legisVC = self.navigationController?.topViewController as! LegislatorTableViewController
        legisVC.selectedState = selectedState
        DispatchQueue.main.async {
            legisVC.fileterByState()
            legisVC.tableView.reloadData()
        }
        //self.navigationController?.pushViewController(legislatorVC, animated: true)

    }

    
    // Mark: Actions
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
         self.slideMenuController()?.openLeft()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
