//
//  ContainerViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 11/26/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        print("awakeFromNib")
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LegislatorTableViewController") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") {
            self.leftViewController = controller
        }
        print("awake middle")
        super.awakeFromNib()
        print("awake Over")
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
