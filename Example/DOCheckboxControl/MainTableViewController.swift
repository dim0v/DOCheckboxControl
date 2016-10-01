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
        
        programmaticalySwitchableCheckbox.isEnabled = false
        switchInstantlyBtn.titleLabel?.numberOfLines = 0;
        switchAnimatedBtn.titleLabel?.numberOfLines = 0;
        switchInstantlyBtn.titleLabel?.textAlignment = NSTextAlignment.center;
        switchAnimatedBtn.titleLabel?.textAlignment = NSTextAlignment.center;
    }
    
    @IBAction func switchAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.isSelected, animated: true)
    }
    
    @IBAction func switchNotAnimated() {
        programmaticalySwitchableCheckbox.setSelected(!programmaticalySwitchableCheckbox.isSelected, animated: false)
    }
}
