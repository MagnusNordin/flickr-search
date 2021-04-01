//
//  UIColor+RGB.swift
//  test
//
//  Created by magnod on 2021-03-31.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
