//
//  UIView+GetConstraints.swift
//  Created by Paul Rolfe on 7/31/15.
//  Copyright (c) 2015 Paul Rolfe. All rights reserved.
//
/*

The idea is that you can call view.ip_topConstraint or view.ip_heightConstraint on any view and you'll be given the editable constraint that deals with that attribute.
Optionally you can use the base function ip_constraintForAttribute() and pass in the toItem and itemAttribute. It is less convienient but more accurate.

*/
import Foundation
import UIKit

public extension UIView {
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_widthConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Width)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_heightConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Height)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_topConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Top)
    }

    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_bottomConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Bottom)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_leadingConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Leading)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_trailingConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Trailing)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_centerXConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.CenterX)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_centerYConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.CenterY)
    }
    
    /// This computed property result may be unexpected when inspecting views with multiple constraints on an attribute.
    public var ip_aspectRatioConstraint: NSLayoutConstraint? {
        return ip_constraintForAttribute(.Height, toView: self, viewAttribute: .Width)
    }
    
    /**
    More precise way of getting constraints for a view. The constraint does not have to belong to the reciever -- this method searches the superview for the matching constraint as well.
    
    :param: attribute     Attribute to look for belonging to the receiver
    :param: toItem        Probably a UIView, that the receiver is related to.
    :param: itemAttribute Attribute that should be used with the toItem
    
    :returns: The first constraint that matches. May return unexpected constraint if receiver contains multiple constraints with this item and itemAttribute.
    */
    public func ip_constraintForAttribute(attribute: NSLayoutAttribute, onView view1: UIView? = self, toView view2: UIView? = nil, viewAttribute: NSLayoutAttribute? = nil) -> NSLayoutConstraint? {
        
        if let toAttribute = itemAttribute, let toItem = view2 {
            
            return constraints.filter { constraint in
                return constraint.ip_relatesView(view: view1, viaAttribute: attribute, toView: toItem, andItsAttribute: toAttribute)
                }
                .first
            
        } else if let toItem = view2 {
            
            return constraints.filter { constraint in
                return constraint.ip_relatesView(view: view1, viaAttribute: attribute, toView: toItem)
                }
                .first
            
        } else {
            
            if attribute == .Height || attribute == .Width {
                //For size constraints
                return constraints.filter { constraint in
                    return constraint.ip_isIntrinsicConstraintWithView(view: view1, andAttribute: attribute)
                    }
                    .first
                
            } else {
                // For simple positioning constraints
                return constraints.filter { constraint in
                    return constraint.ip_relatesView(view: view1, viaAttribute: attribute)
                    }
                    .first
                
            }
        }
        
    }
}

extension NSLayoutConstraint {
    
    public func ip_relatesView(view view1: UIView,
        viaAttribute attribute1: NSLayoutAttribute,
        toView view2: UIView,
        andItsAttribute attribute2: NSLayoutAttribute) -> Bool {
            
            let possibility1 = (firstItem as? UIView == view1 && firstAttribute == attribute1 && secondItem as? UIView == view2 && secondAttribute == attribute2)
            
            let possibility2 = (secondItem as? UIView == view1 && secondAttribute == attribute1 && firstItem as? UIView == view2 && firstAttribute == attribute2)
            
            return possibility1 || possibility2
    }
    
    public func ip_relatesView(view view1: UIView,
        viaAttribute attribute1: NSLayoutAttribute,
        toView view2: UIView) -> Bool {
            
            let possibility1 = (firstItem as? UIView == view1 && firstAttribute == attribute1 && secondItem as? UIView == view2)
            
            let possibility2 = (secondItem as? UIView == view1 && secondAttribute == attribute1 && firstItem as? UIView == view2)
            
            return possibility1 || possibility2
    }
    
    public func ip_relatesView(view view1: UIView,
        viaAttribute attribute1: NSLayoutAttribute) -> Bool {
            
            let possibility1 = (firstItem as? UIView == view1 && firstAttribute == attribute1)
            
            let possibility2 = (secondItem as? UIView == view1 && secondAttribute == attribute1)
            
            return possibility1 || possibility2
    }
    
    public func ip_isIntrinsicConstraintWithView(view view1: UIView,
        andAttribute attribute1: NSLayoutAttribute) -> Bool {
            
            return (firstItem as? UIView == view1 && firstAttribute == attribute1)
    }
}
