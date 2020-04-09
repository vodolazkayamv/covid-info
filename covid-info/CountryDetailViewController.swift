//
//  CountryDetailViewController.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 08/04/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import UIKit
import SwiftUI

class CountryDetailViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    var country : JHUCountryInfo = JHUCountryInfo();
    private var structureStack : UIStackView!
    private var chartsStack : UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF", alpha: 1)
        structureStack = UIStackView()
        structureStack.axis = .horizontal
        structureStack.alignment = .center
        self.view.addSubview(structureStack)
        structureStack.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            structureStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            structureStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            structureStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            structureStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        

        chartsStack = UIStackView()
        chartsStack.axis = .horizontal
        chartsStack.alignment = .center
        structureStack.addArrangedSubview(chartsStack)

        addCasesHistoryChart()
        addDeathsHistoryChart()
    }
    
    func addCasesHistoryChart() {
        var points : [ChartDataPoint] = []
        for i in 1..<country.history.casesHistory.count {
            let item = country.history.casesHistory[country.history.casesHistory.count - i]
            let previousItem = country.history.casesHistory[country.history.casesHistory.count - i - 1]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let string = dateFormatter.string(from: item.date)
            let point : ChartDataPoint = ChartDataPoint(key: string, value: Double(previousItem.number - item.number))
            points.append(point)
        }
        let chartTitle = NSLocalizedString("Cases history", comment: "Cases history")
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: chartTitle, rateValue: country.casesDeviation)
        chart.title = NSLocalizedString("Cases", comment: "Cases")
        chart.legend = NSLocalizedString("all time",comment: "all time")
        let childView = UIHostingController(rootView: chart)
        addChild(childView)
        childView.view.bounds = view.frame.insetBy(dx: 0.0, dy: -15.0);
        chartsStack.addArrangedSubview(childView.view)
    }
    
    func addDeathsHistoryChart() {
        var points : [ChartDataPoint] = []
        for i in 1..<country.history.deathHistory.count {
            let item = country.history.deathHistory[country.history.deathHistory.count - i]
            let previousItem = country.history.deathHistory[country.history.deathHistory.count - i - 1]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let string = dateFormatter.string(from: item.date)
            let point : ChartDataPoint = ChartDataPoint(key: string, value: Double(previousItem.number - item.number))
            points.append(point)
        }
        
        let lineChartStyle = ChartStyle(
            backgroundColor: Color.white,
            accentColor: Color.init(.orange),
            gradientColor: GradientColor(start: Colors.OrangeEnd, end: Colors.OrangeStart),
            textColor: Color.black,
            legendTextColor: Color.gray,
            dropShadowColor: Color.gray,
            lineBackgroundGradient: Gradient(colors: [Colors.OrangeStart, .white]))

        let chartTitle = NSLocalizedString("Cases history", comment: "Cases history")
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: chartTitle, style: lineChartStyle, rateValue: country.deathDeviation)
        chart.title = NSLocalizedString("Deaths",comment: "Deaths")
        chart.legend = NSLocalizedString("all time",comment: "all time")
        
        let childView = UIHostingController(rootView: chart)
        addChild(childView)
        childView.view.bounds = view.frame.insetBy(dx: 0.0, dy: -15.0);
        chartsStack.addArrangedSubview(childView.view)
    }

}

