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
    static let didReceiveCovid19APICountryData = Notification.Name("didReceiveCovid19APICountryData")
    static let didReceiveCovid19APICountryHistoryData = Notification.Name("didReceiveCovid19APICountryHistoryData")

    
    static let didReceiveNewsData = Notification.Name("didReceiveNewsData")
    static let didReceiveBusinessData = Notification.Name("didReceiveBusinessData")
    static let didReceiveNewsHealthData = Notification.Name("didReceiveNewsHealthData")
    static let didReceiveNewsTopData = Notification.Name("didReceiveNewsTopData")

    static let didLoadImageForArticle = Notification.Name("didLoadImageForArticle")

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
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
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

