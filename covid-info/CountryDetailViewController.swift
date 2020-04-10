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
        structureStack.axis = .vertical
        structureStack.alignment = .leading
        self.view.addSubview(structureStack)
        structureStack.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            structureStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            structureStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 25),
            structureStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            structureStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let titleLabel : UILabel = UILabel()
        titleLabel.text = "\(country.country)"
        titleLabel.font = .systemFont(ofSize: 24, weight: .black)
        structureStack.addArrangedSubview(titleLabel)
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.text = "Detailed statistics"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .thin)
        structureStack.addArrangedSubview(subtitleLabel)

        chartsStack = UIStackView()
        chartsStack.axis = .horizontal
        chartsStack.alignment = .center
        chartsStack.spacing = 10
        structureStack.addArrangedSubview(chartsStack)

        addCasesHistoryChart()
        addDeathsHistoryChart()
        
        let spacer : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
        structureStack.addArrangedSubview(spacer)
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
        
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: "Cases history", rateValue: country.casesDeviation)
        chart.title = "Cases"
        chart.legend = "all time"
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
        
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: "Cases history", style: lineChartStyle, rateValue: country.deathDeviation)
        chart.title = "Deaths"
        chart.legend = "all time"
        
        let childView = UIHostingController(rootView: chart)
        addChild(childView)
        childView.view.bounds = view.frame.insetBy(dx: 0.0, dy: -15.0);
        chartsStack.addArrangedSubview(childView.view)
    }

}

