/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Original Inspiration & Author
 * Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

fileprivate var AssociatedInstanceKey: UInt8 = 0

fileprivate struct AssociatedInstance {
    /// A boolean indicating whether Motion is enabled.
    fileprivate var isEnabled: Bool
    
    /// An optional reference to the motion identifier.
    fileprivate var identifier: String?
    
    /// An optional reference to the motion animations.
    fileprivate var animations: [MotionAnimation]?
    
    /// An optional reference to the motion transition animations.
    fileprivate var transitions: [MotionTransition]?
    
    /// An alpha value.
    fileprivate var alpha: CGFloat?
}

fileprivate extension UIView {
    /// AssociatedInstance reference.
    fileprivate var associatedInstance: AssociatedInstance {
        get {
            return AssociatedObject.get(base: self, key: &AssociatedInstanceKey) {
                return AssociatedInstance(isEnabled: true, identifier: nil, animations: nil, transitions: nil, alpha: 1)
            }
        }
        set(value) {
            AssociatedObject.set(base: self, key: &AssociatedInstanceKey, value: value)
        }
    }
}

public extension UIView {
    /// A boolean that indicates whether motion is enabled.
    @IBInspectable
    var isMotionEnabled: Bool {
        get {
            return associatedInstance.isEnabled
        }
        set(value) {
            associatedInstance.isEnabled = value
        }
    }
    
    /// An identifier value used to connect views across UIViewControllers.
    @IBInspectable
    var motionIdentifier: String? {
        get {
            return associatedInstance.identifier
        }
        set(value) {
            associatedInstance.identifier = value
        }
    }
    
    /// The animations to run.
    var motionAnimations: [MotionAnimation]? {
        get {
            return associatedInstance.animations
        }
        set(value) {
            associatedInstance.animations = value
        }
    }
    
    /// The animations to run while in transition.
    var motionTransitions: [MotionTransition]? {
        get {
            return associatedInstance.transitions
        }
        set(value) {
            associatedInstance.transitions = value
        }
    }
    
    /// The animations to run while in transition.
    //@IBInspectable
    var motionAlpha: CGFloat? {
        get {
            return associatedInstance.alpha
        }
        set(value) {
            associatedInstance.alpha = value
        }
    }

    /// Computes the rotate of the view.
    @objc var motionRotationAngle: CGFloat {
        get {
            return CGFloat(atan2f(Float(transform.b), Float(transform.a))) * 180 / CGFloat(Double.pi)
        }
        set(value) {
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * value / 180)
        }
    }
    
    /// The global position of a view.
    @objc var motionPosition: CGPoint {
        return superview?.convert(layer.position, to: nil) ?? layer.position
    }
    
    /// The layer.transform of a view.
    @objc var motionTransform: CATransform3D {
        get {
            return layer.transform
        }
        set(value) {
            layer.transform = value
        }
    }
    
    /// Computes the scale X axis value of the view.
    @objc var motionScaleX: CGFloat {
        return transform.a
    }
    
    /// Computes the scale Y axis value of the view.
    @objc var motionScaleY: CGFloat {
        return transform.b
    }
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animations: A list of CAAnimations.
     */
    func animate(_ animations: CAAnimation...) {
        layer.animate(animations)
    }
    
    /**
     A function that accepts an Array of CAAnimation objects and executes
     them on the view's backing layer.
     - Parameter animations: An Array of CAAnimations.
     */
    @objc func animate(_ animations: [CAAnimation]) {
        layer.animate(animations)
    }
    
    /**
     A function that accepts a list of MotionAnimation values and executes
     them on the view's backing layer.
     - Parameter animations: A list of MotionAnimation values.
     */
    func motion(_ animations: MotionAnimation...) {
        layer.motion(animations)
    }
    
    /**
     A function that accepts an Array of MotionAnimation values and executes
     them on the view's backing layer.
     - Parameter animations: An Array of MotionAnimation values.
     - Parameter completion: An optional completion block.
     */
    func motion(_ animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        layer.motion(animations, completion: completion)
    }
}

internal extension UIView {
    /// Retrieves a single Array of UIViews that are in the view hierarchy.
    @objc var flattenedViewHierarchy: [UIView] {
        guard isMotionEnabled else {
            return []
        }
        
        if #available(iOS 9.0, *) {
            return isHidden && (superview is UICollectionView || superview is UIStackView || self is UITableViewCell) ? [] : ([self] + subviews.flatMap { $0.flattenedViewHierarchy })
        }
        
        return isHidden && (superview is UICollectionView || self is UITableViewCell) ? [] : ([self] + subviews.flatMap { $0.flattenedViewHierarchy })
    }
    
    /**
     Retrieves the optimized duration based on the given parameters.
     - Parameter fromPosition: A CGPoint.
     - Parameter toPosition: An optional CGPoint.
     - Parameter size: An optional CGSize.
     - Parameter transform: An optional CATransform3D.
     - Returns: A TimeInterval.
     */
    func optimizedDuration(fromPosition: CGPoint, toPosition: CGPoint?, size: CGSize?, transform: CATransform3D?) -> TimeInterval {
        let toPos = toPosition ?? fromPosition
        let fromSize = (layer.presentation() ?? layer).bounds.size
        let toSize = size ?? fromSize
        let fromTransform = (layer.presentation() ?? layer).transform
        let toTransform = transform ?? fromTransform
        
        let realFromPos = CGPoint.zero.transform(fromTransform) + fromPosition
        let realToPos = CGPoint.zero.transform(toTransform) + toPos
        
        let realFromSize = fromSize.transform(fromTransform)
        let realToSize = toSize.transform(toTransform)
        
        let movePoints = realFromPos.distance(realToPos) + realFromSize.bottomRight.distance(realToSize.bottomRight)
        
        // duration is 0.2 @ 0 to 0.375 @ 500
        return 0.208 + Double(movePoints.clamp(0, 500)) / 3000
    }
    
    /**
     Takes a snapshot of a view usinag the UI graphics context.
     - Returns: A UIView with an embedded UIImageView.
     */
    @objc func slowSnapshotView() -> UIView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.frame = bounds
        
        let snapshotView = UIView(frame: bounds)
        snapshotView.addSubview(imageView)
        return snapshotView
    }
}
