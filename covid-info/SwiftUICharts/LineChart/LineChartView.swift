//
//  LineCard.swift
//  LineChart
//
//  Created by András Samu on 2019. 08. 31..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data:ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    @State private var currentKey: String = "NaN"
    let frame = CGSize(width: 180, height: 120)
    private var rateValue: Int
    
    public init(data: [Double],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize? = ChartForm.medium,
                rateValue: Int? = 14,
                dropShadow: Bool? = true,
                valueSpecifier: String? = "%.1f") {
        
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form!
        self.rateValue = rateValue!
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public init(data: ChartData,
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize? = ChartForm.small,
                rateValue: Int? = 14,
                dropShadow: Bool? = true,
                valueSpecifier: String? = "%.1f") {
        
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form!
        self.rateValue = rateValue!
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                .frame(width: self.formSize.width, height: self.formSize.height, alignment: .center)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 2 : 0)
            VStack(alignment: .leading, spacing: 0){
                
                    VStack(alignment: .leading, spacing: 0){
                        Text(self.showIndicatorDot
                            ? "\(Int(self.currentValue))"
                            : self.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                        .lineLimit(nil)
                        .animation(nil)

                        Text(self.showIndicatorDot
                            ? self.currentKey
                            : "\(self.rateValue)" )
                                .font(.callout)
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor :self.style.legendTextColor)
                        .lineLimit(nil)
                        .animation(nil)
                        
                    }.transition(.opacity)
                        .animation(.easeIn(duration: 0.1))
                        .padding([.leading, .top])
                
                
                GeometryReader{ geometry in
                    Line(data: self.data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: self.$touchLocation,
                         showIndicator: self.$showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil),
                         gradient: self.style.gradientColor,
                         backgroundGradient: self.style.lineBackgroundGradient
                    )
                }.clipShape(RoundedRectangle(cornerRadius: 20))
                    .offset(x: 0, y: 0)
            }.frame(width: self.formSize.width, height: self.formSize.height)
        }
        .gesture(DragGesture()
        .onChanged({ value in
            self.touchLocation = value.location
            self.showIndicatorDot = true
            self.getClosestDataPoint(toPoint: value.location, width:self.frame.width, height: self.frame.height)
        })
            .onEnded({ value in
                self.showIndicatorDot = false
            })
        )
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.points
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()!.value + points.min()!.value)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index].value
            self.currentKey = points[index].key
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index].value)*stepHeight)
        }
        return .zero
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(data: [0,18,23,54,32,12,37,17,23,43], title: "Line chart very long title", legend: "Basic", form: ChartForm.small)
                .environment(\.colorScheme, .light)
        }
    }
}
