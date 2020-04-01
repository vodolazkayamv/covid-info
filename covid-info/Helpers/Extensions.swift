//
//  Extensions.swift
//  covidInfo
//
//  Created by Мария Водолазкая on 27.03.2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation
import UIKit


extension Notification.Name {
    static let didReceiveNativeCountryData = Notification.Name("didReceiveNativeCountryData")
    static let didReceiveCountryData = Notification.Name("didReceiveCountryData")

    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

extension Date {
 var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension String {
    func localized() -> String {
        
        guard let preferredLangs = Locale.preferredLanguages.first,
            let currentLang = preferredLangs.components(separatedBy: "-").first else { return "" }
        
        let lang = currentLang == "ar" ? currentLang : "en"
        
        guard let libBundle = Bundle(identifier: "geomatix.cz.covid-info"),
            let path = libBundle.path(forResource: lang, ofType: "lproj"),
            let newBundle = Bundle(path: path) else { return "" }
        return newBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

extension NSAttributedString {
    internal convenience init?(html: String) {
        
        let htmlCropped = html.replacingOccurrences(of: "&lt;/p&gt;&lt;p&gt;&amp;nbsp;&lt;/p&gt;", with: "")
        
        guard let data = htmlCropped.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension NSMutableAttributedString {
    func highlightNeedleIn(haystack:String, needle:String)  {
        let range = (haystack as NSString).range(of: needle)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16) , range: range)
        
    }
    
    func highlightRisingNeedleIn(haystack:String, needle:String)  {
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:14)

        let range = (haystack as NSString).range(of: needle)
        self.setAttributes([.font:fontSuper!,.baselineOffset:3], range: range)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
    }
    func highlightDesendingNeedleIn(haystack:String, needle:String)  {
       let fontSuper:UIFont? = UIFont(name: "Helvetica", size:14)

        let range = (haystack as NSString).range(of: needle)
        self.setAttributes([.font:fontSuper!,.baselineOffset:0], range: range)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen , range: range)
    }
}

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}

extension UIView {
    func dropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
    }
}

