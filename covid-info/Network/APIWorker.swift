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
                        
                        
                        askAPIvia(urlString: "https://corona.lmao.ninja/v2/historical",
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
                                                
                                                var history : HistoryDecoded = HistoryDecoded(country: result.country, casesHistory: [], deathHistory: [], recoveredHistory: [], activeHistory: [])
                                                
                                                if (result.province == nil) {
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
                                                    for item in result.timeline.recovered {
                                                        
                                                        let isoDate = item.key
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "MM/dd/yy"
                                                        let date = dateFormatter.date(from:isoDate)!
                                                        
                                                        let record : Case = Case(date: date, number: item.value)
                                                        history.recoveredHistory.append(record)
                                                    }
                                                    history.casesHistory = history.casesHistory.sorted(by: {
                                                        $0.date.compare($1.date) == .orderedDescending
                                                    })
                                                    history.deathHistory = history.deathHistory.sorted(by: {
                                                        $0.date.compare($1.date) == .orderedDescending
                                                    })
                                                    history.recoveredHistory = history.recoveredHistory.sorted(by: {
                                                        $0.date.compare($1.date) == .orderedDescending
                                                    })
                                                }
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
    
    
    class func askNewsApi_Health() {
        let locale = Locale.current
        let currentRegion = locale.regionCode?.lowercased() ?? ""
        let urlStringPart1 = "https://newsapi.org/v2/top-headlines?apiKey=8c8b05d0b0af4876a95cb405b5c4b874&country="
        let urlStringPart2 = "&category=health&q="
        var query = "COVID"
        if (currentRegion == "ru") {
            query = "коронавирус"
        }
        
        
        askAPIvia(urlString: (urlStringPart1+currentRegion+urlStringPart2+query).encodeUrl, completionHandler: { dataResponse in
            do{
                //                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                //                print(jsonResponse) //Response result
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let newsResponse : NewsApiResponse = try decoder.decode(NewsApiResponse.self, from: dataResponse)
                
                //                print(newsResponse.articles.count, newsResponse.totalResults)
                let dataDict:[String: NewsApiResponse] = ["result": newsResponse]
                NotificationCenter.default.post(name: .didReceiveNewsHealthData, object: self, userInfo: dataDict)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        })
    }
    
    class func askNewsApi_Business() {
        let locale = Locale.current
        let currentRegion = locale.regionCode?.lowercased() ?? ""
        let urlStringPart1 = "https://newsapi.org/v2/top-headlines?apiKey=8c8b05d0b0af4876a95cb405b5c4b874&country="
        let urlStringPart2 = "&category=business&q="
        var query = "COVID"
        if (currentRegion == "ru") {
            query = "коронавирус"
        }
        
        
        askAPIvia(urlString: (urlStringPart1+currentRegion+urlStringPart2+query).encodeUrl, completionHandler: { dataResponse in
            do{
                //                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                //                print(jsonResponse) //Response result
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let newsResponse : NewsApiResponse = try decoder.decode(NewsApiResponse.self, from: dataResponse)
                
                //                print(newsResponse.articles.count, newsResponse.totalResults)
                let dataDict:[String: NewsApiResponse] = ["result": newsResponse]
                NotificationCenter.default.post(name: .didReceiveBusinessData, object: self, userInfo: dataDict)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        })
    }
    
    //
    class func askNewsApi_Top() {
        
        let locale = Locale.current
        let currentRegion = locale.regionCode?.lowercased() ?? ""
        let urlStringPart1 = "https://newsapi.org/v2/top-headlines?apiKey=8c8b05d0b0af4876a95cb405b5c4b874&country="
        let urlStringPart2 = "&q="
        var query = "COVID"
        if (currentRegion == "ru") {
            query = "коронавирус"
        }
        
        askAPIvia(urlString: (urlStringPart1+currentRegion+urlStringPart2+query).encodeUrl, completionHandler: { dataResponse in
            do{
                //                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as AnyObject
                //                print(jsonResponse) //Response result
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let newsResponse : NewsApiResponse = try decoder.decode(NewsApiResponse.self, from: dataResponse)
                
                //                    print(newsResponse.articles.count, newsResponse.totalResults)
                let dataDict:[String: NewsApiResponse] = ["result": newsResponse]
                NotificationCenter.default.post(name: .didReceiveNewsTopData, object: self, userInfo: dataDict)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        })
    }
    
    
    
    class func askCovid19API_Summary() {
        askAPIvia(urlString: "https://api.covid19api.com/summary",
                  completionHandler: { dataResponse in
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        var countries : Covid19API_Response = try decoder.decode(Covid19API_Response.self, from: dataResponse)
                        
                        countries.Countries = countries.Countries.sorted(by: {
                            $0.TotalConfirmed > $1.TotalConfirmed
                        })
                        let formatter = ISO8601DateFormatter()

                        var cards: [CardInfo] = []
                        
                        for country in countries.Countries {
                            
                            askAPI_confirmedHistory(country: country.Slug, completion: { confirmedHistory in

                                askAPI_deathsHistory(country: country.Slug, completion: { deathsHistory in

                                    askAPI_recoveredHistory(country: country.Slug, completion: { recoveredHistory in
                                        
                                        let cardInfo : CardInfo = CardInfo(countryToday: country, confirmedHistory:confirmedHistory, deathsHistory: deathsHistory, recoveredHistory: recoveredHistory)
                                        cards.append(cardInfo)
                                        
                                        cards = cards.sorted(by: {
                                            $0.active > $1.active
                                        })
                                        
                                        print("\(country.Country)")
                                        let dataDict:[String: [CardInfo]] = ["result": cards]
                                        NotificationCenter.default.post(name: .didReceiveCovid19APICountryData, object: self, userInfo: dataDict)
                                        
                                    })
                                })
                            })
                            
                            
                            
//                            let url = "https://api.covid19api.com/live/country/" + country.Slug + "/status/confirmed/date/" + formatter.string(from: Date.yesterday)
//                            askAPIvia(urlString: url, completionHandler: { dataResponse in
//                                do{
//                                    let decoder = JSONDecoder()
//                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                                    decoder.dateDecodingStrategy = .iso8601
//
//                                    var confirmedHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
//                                    confirmedHistory = confirmedHistory.sorted(by: {
//                                        $0.Date.compare($1.Date) == .orderedAscending
//                                    })
//
//                                    let cardInfo : CardInfo = CardInfo(countryToday: country, confirmedHistory: confirmedHistory, deathsHistory: [], recoveredHistory: [])
//                                    cards.append(cardInfo)
//
//
//                                    let dataDict:[String: [CardInfo]] = ["result": cards]
//                                    NotificationCenter.default.post(name: .didReceiveCovid19APICountryData, object: self, userInfo: dataDict)
//                                } catch let parsingError {
//                                    print("Error", parsingError)
//                                }
//                            })
                        }

                    } catch let parsingError {
                        print("Error", parsingError)
                    }
        })
    }
    
    class func askAPI_confirmedHistory(country : String, completion: @escaping ([Covid19API_CountryHistoryRecord]) -> Void) {
        let urlString = "https://api.covid19api.com/dayone/country/\(country)/status/"
        askAPIvia(urlString: urlString+"confirmed",
                  completionHandler: { dataResponse in
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        var confirmedHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                        confirmedHistory = confirmedHistory.sorted(by: {
                            $0.Date.compare($1.Date) == .orderedDescending
                        })
                        
                        completion(confirmedHistory)
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
        })
        
    }
    
    class func askAPI_deathsHistory(country : String, completion: @escaping ([Covid19API_CountryHistoryRecord]) -> Void) {
        let urlString = "https://api.covid19api.com/dayone/country/\(country)/status/"
        askAPIvia(urlString: urlString+"deaths",
                  completionHandler: { dataResponse in
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        var confirmedHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                        confirmedHistory = confirmedHistory.sorted(by: {
                            $0.Date.compare($1.Date) == .orderedDescending
                        })
                        
                        completion(confirmedHistory)
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
        })
        
    }
    
    class func askAPI_recoveredHistory(country : String, completion: @escaping ([Covid19API_CountryHistoryRecord]) -> Void) {
        let urlString = "https://api.covid19api.com/dayone/country/\(country)/status/"
        askAPIvia(urlString: urlString+"recovered",
                  completionHandler: { dataResponse in
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        var confirmedHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                        confirmedHistory = confirmedHistory.sorted(by: {
                            $0.Date.compare($1.Date) == .orderedDescending
                        })
                        
                        completion(confirmedHistory)
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
        })
        
    }
    
    class func askCovid19API_History(country : String) {
        let urlString = "https://api.covid19api.com/dayone/country/\(country)/status/"
        askAPIvia(urlString: urlString+"confirmed",
                  completionHandler: { dataResponse in
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601
                        var confirmedHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                        confirmedHistory = confirmedHistory.sorted(by: {
                            $0.Date.compare($1.Date) == .orderedAscending
                        })
                        
                        print("got confirmed")
                        askAPIvia(urlString: urlString+"deaths",
                                  completionHandler: { dataResponse in
                                    do{
                                        let decoder = JSONDecoder()
                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                        decoder.dateDecodingStrategy = .iso8601
                                        var deathsHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                                        deathsHistory = deathsHistory.sorted(by: {
                                            $0.Date.compare($1.Date) == .orderedAscending
                                        })
                                        print("got deaths")

                                        askAPIvia(urlString: urlString+"recovered",
                                                  completionHandler: { dataResponse in
                                                    do{
                                                        let decoder = JSONDecoder()
                                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                                        decoder.dateDecodingStrategy = .iso8601
                                                        var recoveredHistory : [Covid19API_CountryHistoryRecord] = try decoder.decode([Covid19API_CountryHistoryRecord].self, from: dataResponse)
                                                        recoveredHistory = recoveredHistory.sorted(by: {
                                                            $0.Date.compare($1.Date) == .orderedAscending
                                                        })
                                                        
                                                        print("got recovered")

                                                        
                                                        let dataDict:[String: [Covid19API_CountryHistoryRecord]] = ["confirmed": confirmedHistory, "deaths" : deathsHistory, "recovered" : recoveredHistory]
                                                        NotificationCenter.default.post(name: .didReceiveCovid19APICountryHistoryData, object: self, userInfo: dataDict)
                                                        
                                                        
                                                    } catch let parsingError {
                                                        print("Error", parsingError)
                                                    }
                                        })
                                        
                                    } catch let parsingError {
                                        print("Error", parsingError)
                                    }
                        })
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
        })
    }
}
