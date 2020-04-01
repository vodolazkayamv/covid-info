//
//  DTO.swift
//  covidInfo
//
//  Created by Masha Vodolazkaya on 29/03/2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation
import UIKit

struct COVIDStat : Decodable {
    let active, cases, critical, deaths, recovered, todayCases, todayDeaths: Int
    let country : String
    let deathsPerOneMillion, casesPerOneMillion : Float?
    let countryInfo : CountryInfo
    let updated : Date?
}

struct CountryInfo : Decodable {
    let _id : Int?
    let lat, long : Float
    let flag, iso2, iso3 : String?
}

struct History : Decodable  {
    let country : String
    let timeline : Timeline
}

struct Timeline : Decodable  {
    let cases : [String:Int]
    let deaths : [String:Int]
}

struct Case {
    let date : Date
    let number: Int
}

struct HistoryDecoded {
    let country: String
    var casesHistory : [Case]
    var deathHistory : [Case]
}

struct JHUCountryInfo : CustomStringConvertible, Equatable {
    let country : String
    var statisticsToday : COVIDStat
    var history : HistoryDecoded
    var updated : Date? {
        get {
            statisticsToday.updated
        }
    }
    
    init(today: COVIDStat, history: HistoryDecoded) {
        self.statisticsToday = today
        self.country = today.country
        
        self.history = history
    }
    
    init() {
        self.statisticsToday = COVIDStat(active:-1, cases: -1, critical: -1, deaths: -1, recovered: -1, todayCases: -1, todayDeaths: -1, country: "", deathsPerOneMillion: -1, casesPerOneMillion: -1, countryInfo: CountryInfo(_id: -1, lat: -1, long: -1, flag: "", iso2: "", iso3: ""), updated: nil)
        self.country = ""
        
        self.history = HistoryDecoded(country: "", casesHistory: [], deathHistory: [])
    }
    
    static func ==(lhs: JHUCountryInfo, rhs: JHUCountryInfo) -> Bool {
        return lhs.country == rhs.country && lhs.statisticsToday.cases == rhs.statisticsToday.cases
    }
    
    var casesDeviation : Int {
        get {
            if (self.history.casesHistory.count == 0) {
                return 0
            }
            if (self.history.casesHistory.count == 1) {
                return self.history.casesHistory[0].number
            }
            
            let yesterdayCases = self.history.casesHistory[0].number - self.history.casesHistory[1].number
            let todayCases = self.statisticsToday.todayCases
            
            return todayCases - yesterdayCases
        }
    }
    
    var deathDeviation : Int {
        get {
            if (self.history.deathHistory.count == 0) {
                return 0
            }
            if (self.history.deathHistory.count == 1) {
                return self.history.deathHistory[0].number
            }
            
            let yesterdayCases = self.history.deathHistory[0].number  - self.history.deathHistory[1].number
            let todayCases = self.statisticsToday.todayDeaths
            
            return todayCases - yesterdayCases
        }
    }
    
    var description: String {
        get {
            let desc = "\(history)"
            return desc
        }
    }
    
    var lastThreeDaysHistory : [ Case ] {
        get {
            var casesHistory : [Case] = []
            if self.history.casesHistory.count > 3 {
                casesHistory.append(self.history.casesHistory[0])
                casesHistory.append(self.history.casesHistory[1])
                casesHistory.append(self.history.casesHistory[2])
            } else {
                casesHistory.append(contentsOf: self.history.casesHistory)
            }
            var deathsHistory : [Case] = []
            if self.history.deathHistory.count > 3 {
                deathsHistory.append(self.history.deathHistory[0])
                deathsHistory.append(self.history.deathHistory[1])
                deathsHistory.append(self.history.deathHistory[2])
            } else {
                deathsHistory.append(contentsOf: self.history.deathHistory)
            }
            
            var history : [Case] = []
            history.append(contentsOf: casesHistory)
            history.append(contentsOf: deathsHistory)
            
            return history
        }
    }
}



struct Source : Decodable {
    let id : String?
    let name : String
}

struct NewsArticle : Decodable {
    let source : Source
    let author : String?
    let title : String
    let url : String
    let urlToImage : String
    let publishedAt : Date?
    let content : String?
    let description : String
}

struct NewsApiResponse : Decodable {
    let status : String
    let totalResults : Int
    let articles : [NewsArticle]
}

struct Article {
    let id : Int
    let source : Source
    let author : String?
    let title : String
    let url : String
    let publishedAt : Date?
    let content : String?
    let description : String
    var image : UIImage?
}
