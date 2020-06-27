//
//  CountryCardsTableViewController.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 31/03/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import Foundation
import UIKit
import SPStorkController

class CountryCardsTableViewController : UITableViewController {
    
    var cards : [CardInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var filteredCards: [CardInfo] = []
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "COVID-19 Daily Global Update by country"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search Countries", comment: "Search Countries")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCards.count
        }
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
       
        let cardView : UIView = cell.viewWithTag(10) as! UIView
        cardView.layer.cornerRadius = 10
        cardView.dropShadow()
        
        let country: Covid19API_Country
        let confirmedHistory: [Covid19API_CountryHistoryRecord]
        let deathsHistory: [Covid19API_CountryHistoryRecord]

        if isFiltering {
            country = filteredCards[indexPath.row].countryToday
            confirmedHistory = cards[indexPath.row].confirmedHistory
            deathsHistory = cards[indexPath.row].deathsHistory

        } else {
          country = cards[indexPath.row].countryToday
            confirmedHistory = cards[indexPath.row].confirmedHistory
            deathsHistory = cards[indexPath.row].deathsHistory

        }
       // Configure the cell’s contents.
        let titleLabel : UILabel = cell.viewWithTag(11) as! UILabel
        titleLabel.text = country.Country
        
        let placeLabel : UILabel = cell.viewWithTag(14) as! UILabel
        placeLabel.text = "\(indexPath.row+1)"
        
        let updatedLabel : UILabel = cell.viewWithTag(12) as! UILabel
        if let update : Date = country.Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            formatter.locale = Locale.current
            let upstring = formatter.string(from: update)
            updatedLabel.text = upstring
        }
        
        if let countryCode = country.CountryCode?.lowercased() /*country.statisticsToday.countryInfo.iso2?.lowercased()*/ {
            let flagImage : UIImage = UIImage(named: countryCode) ?? UIImage()
            let flagImageView : UIImageView = cell.viewWithTag(13) as! UIImageView
            flagImageView.image = flagImage
            flagImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            flagImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            flagImageView.dropShadow()
            
            flagImageView.contentMode = .scaleAspectFit
        } else {
            Logger.warning("country missing iso2 code: \(country.Country)")
        }
        
        let activeLabel : UILabel = cell.viewWithTag(212) as! UILabel
        let active = country.TotalConfirmed - country.TotalDeaths - country.TotalRecovered
        activeLabel.text = "\(active)"
        let criticalLabel : UILabel = cell.viewWithTag(222) as! UILabel
        //criticalLabel.text = "\(country.statisticsToday.critical)"
        let recoveredLabel : UILabel = cell.viewWithTag(232) as! UILabel
        recoveredLabel.text = "\(country.TotalRecovered)"
        
        let casesAllLabel : UILabel = cell.viewWithTag(312) as! UILabel
        casesAllLabel.text = "\(country.TotalConfirmed)"
        let casesTodayLabel : UILabel = cell.viewWithTag(322) as! UILabel
        casesTodayLabel.text = "\(country.NewConfirmed)"
        
        let casesDevLabel : UILabel = cell.viewWithTag(332) as! UILabel
        
        let newCasesToday = confirmedHistory[0].Cases - confirmedHistory[1].Cases
        let newCasesYesterday = confirmedHistory[1].Cases - confirmedHistory[2].Cases
        
        let casesDev = newCasesToday - newCasesYesterday
        let deviationStringCases = (casesDev > 0
            ? "▲" + "\(casesDev)"
            : "▼" + "\(casesDev * (-1))")
        casesDevLabel.text = deviationStringCases
        casesDevLabel.textColor = country.NewConfirmed > 0 ? UIColor.systemGreen : UIColor.systemRed
        
        let deathsAllLabel : UILabel = cell.viewWithTag(412) as! UILabel
        deathsAllLabel.text = "\(country.TotalDeaths)"
        
        let deathsTodayLabel : UILabel = cell.viewWithTag(422) as! UILabel
        deathsTodayLabel.text = "\(country.NewDeaths)"
        
        let deathsDevLabel : UILabel = cell.viewWithTag(432) as! UILabel
        
        let newDeathsToday = deathsHistory[0].Cases - deathsHistory[1].Cases
        let newDeathsYesterday = deathsHistory[1].Cases - deathsHistory[2].Cases
        
        let deathsDev = newDeathsToday - newDeathsYesterday
        
        let deviationStringDeath = (deathsDev > 0
            ? "▲" + "\(deathsDev)"
            : "▼" + "\(deathsDev * (-1))")
        deathsDevLabel.text = deviationStringDeath
        deathsDevLabel.textColor = country.NewDeaths > 0 ? UIColor.systemRed : UIColor.systemGreen
        


       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country: CardInfo
        if isFiltering {
          country = filteredCards[indexPath.row]
        } else {
          country = cards[indexPath.row]
        }
        
        let controller = CountryDetailViewController()
        
        controller.country = country
        self.presentAsStork(controller,height: 575)
    }
    
}

extension CountryCardsTableViewController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCards = cards.filter { (card: CardInfo) -> Bool in
            return card.countryToday.Country.lowercased().starts(with: searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
