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
    @IBOutlet weak var switchInstantlyBtn: UIButton!
    @IBOutlet weak var switchAnimatedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programmaticalySwitchableCheckbox.enabled = false
        switchInstantlyBtn.titleLabel?.numberOfLines = 0;
        switchAnimatedBtn.titleLabel?.numberOfLines = 0;
        switchInstantlyBtn.titleLabel?.textAlignment = NSTextAlignment.Center;
        switchAnimatedBtn.titleLabel?.textAlignment = NSTextAlignment.Center;
    }
    
    @IBAction func switchAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.selected, animated: true)
    }
    
    @IBAction func switchNotAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.selected, animated: false)
    }
}
