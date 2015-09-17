//
//  DOCheckbox.swift
//  Pods
//
//  Created by Dmytro Ovcharenko on 22.07.15.
//
//

import UIKit

/// Checkbox control. Sends UIControlEvents.ValueChanged event when it's state changes
@IBDesignable
public class CheckboxControl: UIControl {
    
    /// Width of checkmark line. 2 points by default. IBInspectable
    @IBInspectable public var lineWidth: CGFloat = 2.0
    
    /// Color of checkmark. By default is view's tint color. IBInspectable
    @IBInspectable public var lineColor: UIColor! {
        get {
            if _lineColor == nil {
                return tintColor
            }
            return _lineColor
        }
        set {
            _lineColor = newValue
        }
    }
    
    /// Color of checkmark in highlighted state. By default is `lineColor` with alpha set to 0.3. IBInspectable
    @IBInspectable public var lineHighlightedColor: UIColor! {
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
    
    /// Duration of animation between selected/not selected states and highlighted/not highlighted states. IBInspectable
    @IBInspectable public var animateDuration: CGFloat = 0.4
    
    
    /**
    *  A Boolean value that determines the receiver’s selected state.
    *  Specify true if the checkbox is selected; otherwise false. The default is false. This state toggles automatically when touch up happens. IBInspectable
    */
    @IBInspectable override public var selected: Bool {
        get {
            return super.selected
        }
        set {
            setSelected(newValue, animated: false)
        }
    }
    
    /**
    *  A Boolean value that determines whether the receiver is highlighted.
    *  Specify true if the checkbox is highlighted; otherwise false. By default, a checkbox is not highlighted. This state is set automatically when a touch enters and exits during tracking and when there is a touch up. IBInspectable
    */
    @IBInspectable override public var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            setHighlighted(newValue, animated: false)
        }
    }
    
    /**
    Sets the state of the checkbox selection. Can be animated.
    This is called automatically when touch up happens within a view's bounds.
    
    :param: selected New state of checkbox (true/false)
    :param: animated Should animate (true/false)
    */
    public func setSelected(selected:Bool, animated:Bool) {
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
    
    /**
    Sets the state of the checkbox highlight. Can be animated.
    
    :param: highlighted New state of highlight (true/false)
    :param: animated    Should animate (true/false)
    */
    public func setHighlighted(highlighted:Bool, animated:Bool) {
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
    
    /**
    Lays out subviews.
    */
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        lineLayer = nil
        self.setSelected(selected, animated: false)
        self.setHighlighted(highlighted, animated: false)
    }
    
    /**
    Sent to the control when the last touch for the given event completely ends, telling it to stop tracking.
    
    :param: touch A UITouch object that represents a touch on the receiving control during tracking.
    :param: event An event object encapsulating the information specific to the user event.
    */
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch!, withEvent: event!)
        
        if bounds.contains(touch!.locationInView(self)) {
            self.setSelected(!selected, animated: true)
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    //MARK: Backing storage for computed properties
    
    private var _lineHighlightedColor: UIColor?
    
    private var _lineColor: UIColor?
    
    private var _lineLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            lineHighlightedLayer = nil
        }
    }
    
    private var _lineHighlightedLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
        }
    }
    
    //MARK: Helper functions and properties
    
    private func checkmarkLayerWithColor(color:UIColor) -> CAShapeLayer {
        let ret = CAShapeLayer()
        
        ret.strokeColor = color.CGColor
        ret.fillColor   = UIColor.clearColor().CGColor
        ret.lineCap     = kCALineCapRound
        ret.lineJoin    = kCALineJoinRound
        ret.lineWidth   = self.lineWidth
        ret.path        = self.checkmarkPath.CGPath
        
        return ret
    }
    
    private var lineLayer: CAShapeLayer! {
        get {
            if _lineLayer == nil {
                _lineLayer = checkmarkLayerWithColor(lineColor)
                
                self.layer.addSublayer(_lineLayer!)
            }
            return _lineLayer
        }
        set {
            _lineLayer = newValue
        }
    }
    
    private var lineHighlightedLayer: CAShapeLayer! {
        get {
            if _lineHighlightedLayer == nil {
                _lineHighlightedLayer = checkmarkLayerWithColor(lineHighlightedColor)
                
                self.layer.addSublayer(_lineHighlightedLayer!)
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
        ret.insetInPlace(dx: 2 * lineWidth, dy: 2 * lineWidth)
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
}
