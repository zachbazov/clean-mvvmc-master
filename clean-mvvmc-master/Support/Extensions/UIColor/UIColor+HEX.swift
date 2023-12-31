//
//  UIColor+HEX.swift
//  clean-mvvmc-master
//
//  Created by Developer on 28/09/2023.
//

import UIKit

extension UIColor {
    
    static func hexColor(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.magenta
        }
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                       blue: CGFloat(rgb & 0x0000FF) / 255,
                       alpha: 1.0)
    }
}
