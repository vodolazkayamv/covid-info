//
//  StringExtensions.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 03/04/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import Foundation
import UIKit

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
    
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
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
