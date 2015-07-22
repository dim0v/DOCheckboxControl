//
//  CheckboxTableViewCell.swift
//  DOCheckboxControl
//
//  Created by Dmytro Ovcharenko on 22.07.15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import DOCheckboxControl

class CheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkbox: CheckboxControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        checkbox.setHighlighted(highlighted, animated: animated)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        
        if bounds.contains(touch.locationInView(self)) {
            checkbox.setHighlighted(false, animated: true)
            checkbox.setSelected(!checkbox.selected, animated: true);
        }
    }
}
