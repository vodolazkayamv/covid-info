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
    
    
    var country : CardInfo?
    
    private var structureStack : UIStackView!
    private var chartsStack : UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF", alpha: 1)
        structureStack = UIStackView()
        structureStack.axis = .vertical
        structureStack.alignment = .center
        self.view.addSubview(structureStack)
        structureStack.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            structureStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            structureStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            structureStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            structureStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let titleLabel : UILabel = UILabel()
        titleLabel.text = "\(country?.countryToday.Country ?? "nAn")"
        titleLabel.font = .systemFont(ofSize: 24, weight: .black)
        structureStack.addArrangedSubview(titleLabel)
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.text = "Detailed statistics"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .thin)
        structureStack.addArrangedSubview(subtitleLabel)

        chartsStack = UIStackView()
        chartsStack.axis = .vertical
        chartsStack.spacing = 20
        chartsStack.distribution = .fillEqually
        structureStack.addArrangedSubview(chartsStack)
        NSLayoutConstraint.activate([
            chartsStack.leadingAnchor.constraint(equalTo: structureStack.leadingAnchor),
            chartsStack.trailingAnchor.constraint(equalTo: structureStack.trailingAnchor),
        ])
        structureStack.setCustomSpacing(20, after: chartsStack)
        
       
        
        let spacer : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        structureStack.addArrangedSubview(spacer)
        
        
        if let country = country {
            addConfirmedChart(confirmedData: country.confirmedHistory)
            addDeathsChart(confirmedData: country.deathsHistory)
            addRecoveredChart(confirmedData: country.recoveredHistory)


        }
        
    }
    
    func addRecoveredChart(confirmedData: [Covid19API_CountryHistoryRecord]) {
        var points : [ChartDataPoint] = []
        for i in 1..<confirmedData.count {
            let item = confirmedData[confirmedData.count - i].Cases
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let string = dateFormatter.string(from: confirmedData[i].Date)
            let point : ChartDataPoint = ChartDataPoint(key: string, value: Double(item))
            points.append(point)
        }
        
        let lineChartStyle = ChartStyle(
            backgroundColor: Color.white,
            accentColor: Color.init(.orange),
            gradientColor: GradientColor(start: Colors.BorderBlue, end: Colors.DarkPurple),
            textColor: Color.black,
            legendTextColor: Color.gray,
            dropShadowColor: Color.gray,
            lineBackgroundGradient: Gradient(colors: [Colors.OrangeStart, .white]))

        let chartTitle = "Recovered"
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: chartTitle, style: lineChartStyle)
        chart.formSize = ChartForm.large
        
        DispatchQueue.main.async {
            let childView = UIHostingController(rootView: chart)
            self.addChild(childView)
            childView.view.bounds = self.view.frame.insetBy(dx: 0.0, dy: -15.0);
            self.chartsStack.addArrangedSubview(childView.view)
        }
    }
    
    func addDeathsChart(confirmedData: [Covid19API_CountryHistoryRecord]) {
        var points : [ChartDataPoint] = []
        for i in 1..<confirmedData.count {
            let item = confirmedData[confirmedData.count - i].Cases
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let string = dateFormatter.string(from: confirmedData[i].Date)
            let point : ChartDataPoint = ChartDataPoint(key: string, value: Double(item))
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

        let chartTitle = "Deaths"
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: chartTitle, style: lineChartStyle)
        chart.formSize = ChartForm.large

        
        DispatchQueue.main.async {
            let childView = UIHostingController(rootView: chart)
            self.addChild(childView)
            childView.view.bounds = self.view.frame.insetBy(dx: 0.0, dy: -15.0);
            self.chartsStack.addArrangedSubview(childView.view)
        }
    }
    
    func addConfirmedChart(confirmedData: [Covid19API_CountryHistoryRecord]) {
        var points : [ChartDataPoint] = []
        for i in 1..<confirmedData.count {
            let item = confirmedData[confirmedData.count - i].Cases
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let string = dateFormatter.string(from: confirmedData[i].Date)
            let point : ChartDataPoint = ChartDataPoint(key: string, value: Double(item))
            points.append(point)
        }
        
        let lineChartStyle = ChartStyle(
            backgroundColor: Color.white,
            accentColor: Color.init(.orange),
            gradientColor: GradientColor(start: Colors.GradientNeonBlue, end: Colors.GradientLowerBlue),
            textColor: Color.black,
            legendTextColor: Color.gray,
            dropShadowColor: Color.gray,
            lineBackgroundGradient: Gradient(colors: [Colors.OrangeStart, .white]))

        let chartTitle = "Confirmed"
        var chart : LineChartView = LineChartView(data: ChartData(points:points), title: chartTitle, style: lineChartStyle)
        chart.formSize = ChartForm.large

        
        DispatchQueue.main.async {
            let childView = UIHostingController(rootView: chart)
            self.addChild(childView)
            childView.view.bounds = self.view.frame.insetBy(dx: 0.0, dy: -15.0);
            self.chartsStack.addArrangedSubview(childView.view)
        }
    }
}

