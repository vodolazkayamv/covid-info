//
//  CountryCardsTableViewController.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 31/03/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import Foundation
import UIKit

class CountryCardsTableViewController : UITableViewController {
    
    var cards : [JHUCountryInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "123"
        APIWorker.askCOVIDStatisticsAll()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveCountryData, object: APIWorker.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
       
        let cardView : UIView = cell.viewWithTag(10) as! UIView
        cardView.layer.cornerRadius = 10
        cardView.dropShadow()
        
        
       // Configure the cell’s contents.
        let titleLabel : UILabel = cell.viewWithTag(11) as! UILabel
        titleLabel.text = cards[indexPath.row].country
        
        let updatedLabel : UILabel = cell.viewWithTag(12) as! UILabel
        if let update : Date = cards[indexPath.row].updated {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            formatter.locale = Locale.current
            let upstring = formatter.string(from: update)
            updatedLabel.text = upstring
        }
        
        if let countryCode = cards[indexPath.row].statisticsToday.countryInfo.iso2?.lowercased() {
            let flagImage : UIImage = UIImage(named: countryCode) ?? UIImage()
            let flagImageView : UIImageView = cell.viewWithTag(13) as! UIImageView
            flagImageView.image = flagImage
            flagImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            flagImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            flagImageView.dropShadow()
            
            flagImageView.contentMode = .scaleAspectFit
        } else {
            Logger.warning("country missing iso2 code: \(cards[indexPath.row].country)")
        }
        
        let activeLabel : UILabel = cell.viewWithTag(212) as! UILabel
        activeLabel.text = "\(cards[indexPath.row].statisticsToday.active)"
        let criticalLabel : UILabel = cell.viewWithTag(222) as! UILabel
        criticalLabel.text = "\(cards[indexPath.row].statisticsToday.critical)"
        let recoveredLabel : UILabel = cell.viewWithTag(232) as! UILabel
        recoveredLabel.text = "\(cards[indexPath.row].statisticsToday.recovered)"
        
        let casesAllLabel : UILabel = cell.viewWithTag(312) as! UILabel
        casesAllLabel.text = "\(cards[indexPath.row].statisticsToday.cases)"
        let casesTodayLabel : UILabel = cell.viewWithTag(322) as! UILabel
        casesTodayLabel.text = "\(cards[indexPath.row].statisticsToday.todayCases)"
        let casesDevLabel : UILabel = cell.viewWithTag(332) as! UILabel
        casesDevLabel.text = "\(cards[indexPath.row].casesDeviation)"
        
        let deathsAllLabel : UILabel = cell.viewWithTag(412) as! UILabel
        deathsAllLabel.text = "\(cards[indexPath.row].statisticsToday.deaths)"
        let deathsTodayLabel : UILabel = cell.viewWithTag(422) as! UILabel
        deathsTodayLabel.text = "\(cards[indexPath.row].statisticsToday.todayDeaths)"
        let deathsDevLabel : UILabel = cell.viewWithTag(432) as! UILabel
        deathsDevLabel.text = "\(cards[indexPath.row].deathDeviation)"
        


       return cell
    }
    
    @objc func onDidReceiveData(_ notification: Notification)
    {
        if let dataReceived = notification.userInfo as? [String: [JHUCountryInfo]]
        {
            for (_, dataArray) in dataReceived
            {
                cards = dataArray
            }
        }
    }
    
}
