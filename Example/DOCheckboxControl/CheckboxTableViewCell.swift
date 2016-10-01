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
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        checkbox.setHighlighted(highlighted, animated: animated)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if bounds.contains(touch.location(in: self)) {
            checkbox.setHighlighted(false, animated: true)
            checkbox.setSelected(!checkbox.isSelected, animated: true);
        }
    }
}
