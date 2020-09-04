//
//  UIColor+hex.swift
//  TrackEnsureUIKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Methods

    /// RGB CGFloat color initializaer
    /// - Parameters:
    ///   - r: Red component as CGFloat. This value should be between 0 and 255.
    ///   - g: Green component as CGFloat. This value should be between 0 and 255.
    ///   - b: Blue component as CGFloat. This value should be between 0 and 255.
    ///
    /// - returns: Initialized opaque UIColor, i.e. alpha is set to 1.0.
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

    /// Hex sRGB color initializer.
    ///
    /// - parameter hex: Pass in a sRGB color integer using hex notation, i.e. 0xFFFFFF. Make sure to only include 6 hex digits.
    ///
    /// - returns: Initialized opaque UIColor, i.e. alpha is set to 1.0.
    public convenience init<T: FixedWidthInteger & SignedInteger>(hex: T) {
        assert(0...0xFFFFFF ~= hex, "UIColor+Hex: Hex value given to UIColor initializer should only include RGB values, i.e. the hex value should have six digits.")
        let R = (hex >> 16) & 0xFF
        let G = (hex >> 8) & 0xFF
        let B = hex & 0xFF
        self.init(r: CGFloat(R), g: CGFloat(G), b: CGFloat(B))
    }
}
