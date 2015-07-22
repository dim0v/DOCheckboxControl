//
//  MainTableViewController.swift
//  DOCheckboxControl
//
//  Created by Dmytro Ovcharenko on 22.07.15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import DOCheckboxControl

class MainTableViewController: UITableViewController {

    @IBOutlet weak var programmaticalySwitchableCheckbox: CheckboxControl!
    
    override func viewDidLoad() {
        let switchAnimatedButton = UIBarButtonItem(title: "Switch animated", style: UIBarButtonItemStyle.Plain, target: self, action: "switchAnimated")
        let switchNotAnimatedButton = UIBarButtonItem(title: "Switch instantly", style: UIBarButtonItemStyle.Plain, target: self, action: "switchNotAnimated")
        
        self.navigationItem.leftBarButtonItem = switchAnimatedButton
        self.navigationItem.rightBarButtonItem = switchNotAnimatedButton
        
        programmaticalySwitchableCheckbox.enabled = false
    }
    
    dynamic func switchAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.selected, animated: true)
    }
    
    dynamic func switchNotAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.selected, animated: false)
    }
}
