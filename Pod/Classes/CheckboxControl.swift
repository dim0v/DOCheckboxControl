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
open class CheckboxControl: UIControl {
    
    /// Width of checkmark line. 2 points by default. IBInspectable
    @IBInspectable open var lineWidth: CGFloat = 2.0
    
    /// Color of checkmark. By default is view's tint color. IBInspectable
    @IBInspectable open var lineColor: UIColor! {
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
    @IBInspectable open var lineHighlightedColor: UIColor! {
        get {
            if _lineHighlightedColor == nil {
                return lineColor.withAlphaComponent(0.3)
            }
            return _lineHighlightedColor
        }
        set {
            _lineHighlightedColor = newValue
        }
    }
    
    /// Duration of animation between selected/not selected states and highlighted/not highlighted states. IBInspectable
    @IBInspectable open var animateDuration: CGFloat = 0.4
    
    
    /**
    *  A Boolean value that determines the receiver’s selected state.
    *  Specify true if the checkbox is selected; otherwise false. The default is false. This state toggles automatically when touch up happens. IBInspectable
    */
    @IBInspectable override open var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            setSelected(newValue, animated: false)
        }
    }
    
    /**
    *  A Boolean value that determines whether the receiver is highlighted.
    *  Specify true if the checkbox is highlighted; otherwise false. By default, a checkbox is not highlighted. This state is set automatically when a touch enters and exits during tracking and when there is a touch up. IBInspectable
    */
    @IBInspectable override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
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
    open func setSelected(_ selected:Bool, animated:Bool) {
        super.isSelected = selected
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(animated ? animateDuration : 0.0))
        
        if selected {
            lineLayer.strokeStart = 0
            lineLayer.strokeEnd = 1
        } else {
            CATransaction.setCompletionBlock { [unowned self] () -> Void in
                if !self.isSelected {
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
    open func setHighlighted(_ highlighted:Bool, animated:Bool) {
        super.isHighlighted = highlighted
        
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
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        lineLayer = nil
        self.setSelected(isSelected, animated: false)
        self.setHighlighted(isHighlighted, animated: false)
    }
    
    /**
    Sent to the control when the last touch for the given event completely ends, telling it to stop tracking.
    
    :param: touch A UITouch object that represents a touch on the receiving control during tracking.
    :param: event An event object encapsulating the information specific to the user event.
    */
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch!, with: event!)
        
        if bounds.contains(touch!.location(in: self)) {
            self.setSelected(!isSelected, animated: true)
            sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    //MARK: Backing storage for computed properties
    
    fileprivate var _lineHighlightedColor: UIColor?
    
    fileprivate var _lineColor: UIColor?
    
    fileprivate var _lineLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            lineHighlightedLayer = nil
        }
    }
    
    fileprivate var _lineHighlightedLayer: CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
        }
    }
    
    //MARK: Helper functions and properties
    
    fileprivate func checkmarkLayerWithColor(_ color:UIColor) -> CAShapeLayer {
        let ret = CAShapeLayer()
        
        ret.strokeColor = color.cgColor
        ret.fillColor   = UIColor.clear.cgColor
        ret.lineCap     = kCALineCapRound
        ret.lineJoin    = kCALineJoinRound
        ret.lineWidth   = self.lineWidth
        ret.path        = self.checkmarkPath.cgPath
        
        return ret
    }
    
    fileprivate var lineLayer: CAShapeLayer! {
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
    
    fileprivate var lineHighlightedLayer: CAShapeLayer! {
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
    
    fileprivate var checkmarkPath:UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        
        return path
    }
    
    fileprivate var boundsCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate var insetRect:CGRect {
        return bounds.insetBy(dx: 2 * lineWidth, dy: 2 * lineWidth)
    }
    
    fileprivate var innerRadius:CGFloat {
        return min(insetRect.width, insetRect.height) / 2
    }
    
    fileprivate var outerRadius:CGFloat {
        return sqrt(pow(insetRect.width, 2) + pow(insetRect.height, 2)) / 2
    }
    
    fileprivate var startPoint:CGPoint {
        let angle:CGFloat = CGFloat(13 * M_PI / 12);
        return CGPoint( x: boundsCenter.x + innerRadius * cos(angle),
                        y: boundsCenter.y + innerRadius * sin(angle))
    }
    
    fileprivate var middlePoint:CGPoint {
        return CGPoint( x: boundsCenter.x - 0.25 * innerRadius,
                        y: boundsCenter.y + 0.8 * innerRadius)
    }
    
    fileprivate var endPoint:CGPoint {
        let angle:CGFloat = CGFloat(7 * M_PI / 4);
        return CGPoint( x: boundsCenter.x + outerRadius * cos(angle),
                        y: boundsCenter.y + outerRadius * sin(angle))
    }
}
