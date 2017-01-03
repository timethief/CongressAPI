//
//  AboutViewController.swift
//  CongressAPI
//
//  Created by Ziqiang Huang on 12/1/16.
//  Copyright © 2016 Ziqiang Huang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var leftMenuItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        // Do any additional setup after loading the view.
    }
    
    func initButton() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.leftMenuItem.setTitleTextAttributes(attributes, for: .normal)
        self.leftMenuItem.title = String.fontAwesomeIcon(name: .bars)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftMenuOpen(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
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
