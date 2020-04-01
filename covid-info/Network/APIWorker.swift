//
//  APIWorker.swift
//  covidInfo
//
//  Created by Мария Водолазкая on 28.03.2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation

class APIWorker {
    
    class func askCOVIDStatisticsAll() {
        askAPIvia(urlString: "https://corona.lmao.ninja/countries?sort=active",
                  completionHandler: { dataResponse in
                    do{
                        //                        let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                        //                        print(jsonResponse) //Response result
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .millisecondsSince1970
                        let countries : [COVIDStat] = try decoder.decode([COVIDStat].self, from: dataResponse)
                        
                        
                        askAPIvia(urlString: "https://corona.lmao.ninja/v2/historical/",
                                  completionHandler: { dataResponse in
                                    do{
                                        let decoder = JSONDecoder()
                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                        decoder.dateDecodingStrategy = .millisecondsSince1970
                                        let resultArray : [History] = try decoder.decode([History].self, from: dataResponse)
                                        
                                        var info : [JHUCountryInfo] = []
                                        for country in countries {
                                            
                                            if let location = resultArray.firstIndex(where: { $0.country.lowercased() == country.country.lowercased() }) {
                                                // you know that location is not nil here
                                                let result = resultArray[location]
                                                
                                                var history : HistoryDecoded = HistoryDecoded(country: result.country, casesHistory: [], deathHistory: [])
                                                for item in result.timeline.cases {
                                                    
                                                    let isoDate = item.key
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "MM/dd/yy"
                                                    let date = dateFormatter.date(from:isoDate)!
                                                    
                                                    let record : Case = Case(date: date, number: item.value)
                                                    history.casesHistory.append(record)
                                                }
                                                for item in result.timeline.deaths {
                                                    
                                                    let isoDate = item.key
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "MM/dd/yy"
                                                    let date = dateFormatter.date(from:isoDate)!
                                                    
                                                    let record : Case = Case(date: date, number: item.value)
                                                    history.deathHistory.append(record)
                                                }
                                                history.casesHistory = history.casesHistory.sorted(by: {
                                                    $0.date.compare($1.date) == .orderedDescending
                                                })
                                                history.deathHistory = history.deathHistory.sorted(by: {
                                                    $0.date.compare($1.date) == .orderedDescending
                                                })
                                                
                                                let JHUSomeCountryInfo : JHUCountryInfo = JHUCountryInfo(today: country, history: history)
                                                
                                                let locale = Locale.current
                                                let currentRegion = locale.regionCode?.lowercased() ?? ""
                                                
                                                if currentRegion == JHUSomeCountryInfo.statisticsToday.countryInfo.iso2?.lowercased() {
                                                    info.insert(JHUSomeCountryInfo, at: 0)
                                                } else {
                                                    info.append(JHUSomeCountryInfo)
                                                }
                                            }
                                            
                                            let dataDict:[String: [JHUCountryInfo]] = ["result": info]
                                            NotificationCenter.default.post(name: .didReceiveCountryData, object: self, userInfo: dataDict)
                                            
                                        }
                                    } catch let parsingError {
                                        print("Error", parsingError)
                                    }
                        })
                        
                        
                        
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
        })
    }
    
    private class func askAPIvia(urlString:String, completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            completionHandler(dataResponse)
            
        }
        task.resume()
    }
    
    class func askCOVIDStatisticsRussia_Actual() {
        guard let url = URL(string: "https://corona.lmao.ninja/countries/Russia") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                //                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                //                print(jsonResponse) //Response result
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result : COVIDStat = try decoder.decode(COVIDStat.self, from: dataResponse)
                //let stats : [COVIDStat] = result.filter{ $0.country == "Russia" }
                
                print(result)
                let dataDict:[String: COVIDStat] = ["result": result]
                
                NotificationCenter.default.post(name: .didReceiveNativeCountryData, object: self, userInfo: dataDict)
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    class func askCOVIDStatisticsRussia_Historical() {
        guard let url = URL(string: "https://corona.lmao.ninja/v2/historical/russia") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                //                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                //                print(jsonResponse) //Response result
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result : History = try decoder.decode(History.self, from: dataResponse)
                //let stats : [COVIDStat] = result.filter{ $0.country == "Russia" }
                
                var h : HistoryDecoded = HistoryDecoded(country: result.country, casesHistory: [], deathHistory: [])
                for item in result.timeline.cases {
                    
                    let isoDate = item.key
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yy"
                    let date = dateFormatter.date(from:isoDate)!
                    
                    let record : Case = Case(date: date, number: item.value)
                    h.casesHistory.append(record)
                }
                h.casesHistory = h.casesHistory.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                
                print(result)
                let dataDict:[String: History] = ["result": result]
                
                NotificationCenter.default.post(name: .didReceiveNativeCountryData, object: self, userInfo: dataDict)
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
