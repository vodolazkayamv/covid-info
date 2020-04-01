//
//  ColorExtensions.swift
//  covidInfo
//
//  Created by Masha Vodolazkaya on 30/03/2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation
import UIKit
//FEC8D8

extension UIColor {
    public class var patelPink: UIColor {
        return UIColor.init(hexString: "FEC8D8");
    }
    public class var pastelDeathFont: UIColor {
//        return UIColor.init(hexString: "F07249");
        return UIColor.init(hexString: "FF9AA2");
    }
    public class var pastelDeathBackground: UIColor {
        return UIColor.init(hexString: "FFECF0");
        //return UIColor.init(hexString: "FFDAC1");
    }
    
    public class var pastelCasesFont: UIColor {
        return UIColor.init(hexString: "78C5DC");
    }
    public class var pastelCasesBackground: UIColor {
        return UIColor.init(hexString: "EFF9FD");
    }
    
    public class var pastelRecoveredFont: UIColor {
        return UIColor.init(hexString: "99B49F");
    }
    public class var pastelRecoveredBackground: UIColor {
        return UIColor.init(hexString: "E7FFF6");
    }
    
    public class var textDarkGrayColor : UIColor {
        return UIColor.init(hexString: "151515")
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

}
