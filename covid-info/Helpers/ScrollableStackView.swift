//
//  ScrollableStackView.swift
//  covidInfo
//
//  Created by Мария Водолазкая on 27.03.2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation
import UIKit

class ScrollableStackView: UIScrollView {
    
    public var stackView:  UIStackView!
    
    
    init(superview: UIView) {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        superview.addSubview(self);
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            
            self.widthAnchor.constraint(equalTo: superview.widthAnchor),
            self.heightAnchor.constraint(equalTo: superview.heightAnchor),
        ])
        
        
        self.stackView = UIStackView();
        self.stackView.spacing = 10;
        self.stackView.axis = .vertical
        
        self.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false;
        let trailingOffset = -(UIScreen.main.bounds.height / 3 );
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: trailingOffset),
            self.stackView.widthAnchor.constraint(equalTo: superview.widthAnchor),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWithStubsVertical() {
        for i in 1...10 {
            let rectangle = UIView()
            rectangle.translatesAutoresizingMaskIntoConstraints = false;
            rectangle.heightAnchor.constraint(equalToConstant: CGFloat(150 + i*10)).isActive = true
            rectangle.backgroundColor = .cyan
            
            self.stackView.addArrangedSubview(rectangle);
        }
    }
    
    func fillWithStubsHorizontal() {
        self.stackView.axis = .horizontal
        for i in 1...10 {
            let rectangle = UIView()
            rectangle.translatesAutoresizingMaskIntoConstraints = false;
            rectangle.widthAnchor.constraint(equalToConstant: CGFloat(15 + i*5)).isActive = true
            rectangle.backgroundColor = .systemPink
            
            self.stackView.addArrangedSubview(rectangle);
        }
    }
    
    func addArrangedViewWithHeight(view: UIView)  {
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        self.stackView.addArrangedSubview(view)
    }
    
    func addArrangedView(view: UIView)  {
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.stackView.addArrangedSubview(view)
    }
    
    func addArrangedView(view: UIView, at: Int)  {
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.stackView.insertArrangedSubview(view, at: at)
    }
    
    func addArrangedView(view: UIView, aboveSubview: UIView)  {
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.stackView.insertSubview(view, aboveSubview: aboveSubview)
    }
    func addArrangedView(view: UIView, belowSubview: UIView)  {
//        view.translatesAutoresizingMaskIntoConstraints = false;
        self.stackView.insertSubview(view, belowSubview: belowSubview)
    }
    
}
