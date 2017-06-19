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
 
public enum CAMediaTimingFunctionType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case standard
    case deceleration
    case acceleration
    case sharp
    case easeOutBack
}
 
public extension CAMediaTimingFunction {
    //  default
    @objc static let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    @objc static let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    @objc static let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    @objc static let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

    //  material  
    @objc static let standard = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    @objc static let deceleration = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1)
    @objc static let acceleration = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1, 1)
    @objc static let sharp = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.6, 1)
    
    // easing.net
    @objc static let easeOutBack = CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.75)
 
    /**
     Converts a string name matching a CAMediaTimingFunctionType to a 
     CAMediaTimingFunction value.
     - Parameter mediaTimingFunctionType: A String.
     */
    @objc static func from(mediaTimingFunctionType: String) -> CAMediaTimingFunction? {
        switch mediaTimingFunctionType {
        case "linear":
            return .linear
        case "easeIn":
            return .easeIn
        case "easeOut":
            return .easeOut
        case "easeInOut":
            return  .easeInOut
        case "standard":
            return .standard
        case "deceleration":
            return  .deceleration
        case "acceleration":
            return .acceleration
        case "sharp":
            return .sharp
        case "easeOutBack":
            return .easeOutBack
        default:
            return nil
        }
    }
    
    /**
     Converts a CAMediaTimingFunctionType to a CAMediaTimingFunction value.
     - Parameter mediaTimingFunctionType: A CAMediaTimingFunctionType.
     */
    static func from(mediaTimingFunctionType: CAMediaTimingFunctionType) -> CAMediaTimingFunction {
        switch mediaTimingFunctionType {
        case .linear:
            return .linear
        case .easeIn:
            return .easeIn
        case .easeOut:
            return .easeOut
        case .easeInOut:
            return  .easeInOut
        case .standard:
            return .standard
        case .deceleration:
            return  .deceleration
        case .acceleration:
            return .acceleration
        case .sharp:
            return .sharp
        case .easeOutBack:
            return .easeOutBack
        }
    }
}
