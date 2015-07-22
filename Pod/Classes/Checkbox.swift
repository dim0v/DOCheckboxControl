//
//  DOCheckbox.swift
//  Pods
//
//  Created by Dmytro Ovcharenko on 22.07.15.
//
//

import UIKit

@IBDesignable
class Checkbox: UIControl {
    
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineColor: UIColor = UIColor.blackColor()
    
    private var _lineHighlightedColor: UIColor?
    
    @IBInspectable var lineHighlightedColor: UIColor! {
        get {
            if _lineHighlightedColor == nil {
                return lineColor.colorWithAlphaComponent(0.3)
            }
            return _lineHighlightedColor
        }
        set {
            _lineHighlightedColor = newValue
        }
    }
    @IBInspectable var animateDuration: CGFloat = 0.4
    
    @IBInspectable override var selected: Bool {
        get {
            return super.selected
        }
        set {
            setSelected(newValue, animated: false)
        }
    }
    
    @IBInspectable override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            setHighlighted(newValue, animated: false)
        }
    }
    
    func setSelected(selected:Bool, animated:Bool) {
        super.selected = selected
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(animated ? animateDuration : 0.0))
        
        if selected {
            lineLayer.strokeStart = 0
            lineLayer.strokeEnd = 1
        } else {
            CATransaction.setCompletionBlock { [unowned self] () -> Void in
                if !self.selected {
                    self.lineLayer.strokeStart = 0
                    self.lineLayer.strokeEnd = 0
                }
            }
            lineLayer.strokeStart = 1
            lineLayer.strokeEnd = 1
        }
        
        CATransaction.commit()
    }
    
    func setHighlighted(highlighted:Bool, animated:Bool) {
        super.highlighted = highlighted
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(animated ? animateDuration : 0.0))
        
        if highlighted {
            lineLayer.opacity = 0
            lineHighlightedLayer.opacity = 1
        } else {
            lineLayer.opacity = 1
            lineHighlightedLayer.opacity = 0
        }
        
        CATransaction.commit()
    }
    
    private func checkmarkLayerWithColor(color:UIColor) -> CAShapeLayer {
        var ret = CAShapeLayer()
        
        ret.strokeColor = color.CGColor
        ret.fillColor   = UIColor.clearColor().CGColor
        ret.lineCap     = kCALineCapRound
        ret.lineJoin    = kCALineJoinRound
        ret.lineWidth   = self.lineWidth
        ret.path        = self.checkmarkPath.CGPath
        
        return ret
    }
    
    private var _lineLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            lineHighlightedLayer = nil
        }
    }
    
    private var lineLayer: CAShapeLayer! {
        get {
            if _lineLayer == nil {
                _lineLayer = checkmarkLayerWithColor(lineColor)
                
                self.layer.addSublayer(_lineLayer)
            }
            return _lineLayer
        }
        set {
            _lineLayer = newValue
        }
    }
    
    private var _lineHighlightedLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
        }
    }
    
    private var lineHighlightedLayer: CAShapeLayer! {
        get {
            if _lineHighlightedLayer == nil {
                _lineHighlightedLayer = checkmarkLayerWithColor(lineHighlightedColor)
                
                self.layer.addSublayer(_lineHighlightedLayer)
            }
            
            return _lineHighlightedLayer
        }
        set {
            _lineHighlightedLayer = newValue
        }
    }
    
    private var checkmarkPath:UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(middlePoint)
        path.addLineToPoint(endPoint)
        
        return path
    }
    
    private var boundsCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var insetRect:CGRect {
        var ret = bounds
        ret.inset(dx: 2 * lineWidth, dy: 2 * lineWidth)
        return ret
    }
    
    private var innerRadius:CGFloat {
        return min(insetRect.width, insetRect.height) / 2
    }
    
    private var outerRadius:CGFloat {
        return sqrt(pow(insetRect.width, 2) + pow(insetRect.height, 2)) / 2
    }
    
    private var startPoint:CGPoint {
        let angle:CGFloat = CGFloat(13 * M_PI / 12);
        return CGPoint( x: boundsCenter.x + innerRadius * cos(angle),
                        y: boundsCenter.y + innerRadius * sin(angle))
    }
    
    private var middlePoint:CGPoint {
        return CGPoint( x: boundsCenter.x - 0.25 * innerRadius,
                        y: boundsCenter.y + 0.8 * innerRadius)
    }
    
    private var endPoint:CGPoint {
        let angle:CGFloat = CGFloat(7 * M_PI / 4);
        return CGPoint( x: boundsCenter.x + outerRadius * cos(angle),
                        y: boundsCenter.y + outerRadius * sin(angle))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineLayer = nil
        self.setSelected(selected, animated: false)
        self.setHighlighted(highlighted, animated: false)
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        if bounds.contains(touch.locationInView(self)) {
            self.setSelected(!selected, animated: true)
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
}
