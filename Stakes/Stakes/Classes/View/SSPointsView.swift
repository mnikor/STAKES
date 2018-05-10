//
//  SSPointsView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/23/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import EFCountingLabel

class SSPointsView: UIView {
    
    
    // MARK: Private Properties
    private let points = SSPoint()
    private let viewSize = CGSize(width: 72.0, height: 19.0)
    private var currentPointsLabel: EFCountingLabel!
    private var starImageView = UIImageView()
    
    
    // MARK: Initializers
    init() {
        super.init(frame: CGRect(origin: .zero, size: viewSize))
        
        // Init StarImageView
        initStarImageView()
        
        // Init CurrentPointsLabel
        points.tempPoints = points.currentPoints
        currentPointsLabel = EFCountingLabel(frame: CGRect(origin: .zero, size: viewSize))
        currentPointsLabel.textColor = UIColor.fromRGB(rgbValue: 0xE4BD85)
        currentPointsLabel.textAlignment = .right
        currentPointsLabel.text = points.getCurrentPoints()
        currentPointsLabel.font = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: 16.0)
        
        // Settings EFCountingLabel
        currentPointsLabel.formatBlock = { [weak self] (value) in
            
            let intValue: Int = Int(value)
            self?.updatePointsLabelFrame()
            return intValue < 0 ? intValue.description : "+" + intValue.description
        }
        
        addSubview(currentPointsLabel)
        addSubview(starImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Public funcs
    func updatePointsView(withCounting: Bool) {
        
        if withCounting {
            
            // Update Points Label with animation
            let fromPoints: CGFloat = CGFloat(points.tempPoints)
            let toPoints: CGFloat = CGFloat(points.currentPoints)
            currentPointsLabel.countFrom(fromPoints, to: toPoints, withDuration: 2.0)
            
        } else {
            
            // Static updating of Points Label
            currentPointsLabel.text = points.getCurrentPoints()
        }
        updatePointsLabelFrame()
    }
    
    func updatePointsViewWithCounting() {
        
        let fromPoints: CGFloat = CGFloat(points.tempPoints)
        let toPoints: CGFloat = CGFloat(points.currentPoints)
        currentPointsLabel.countFrom(fromPoints, to: toPoints, withDuration: 3.0)
        
        currentPointsLabel.text = points.getCurrentPoints()
        updatePointsLabelFrame()
    }
    
    
    // MARK: Private funcs
    private func initStarImageView() {
        
        let starImage = UIImage(named: "yellow_star")
        starImageView = UIImageView(image: starImage)
        starImageView.tintColor = .black
        starImageView.frame.origin = CGPoint(x: frame.width - starImageView.frame.width, y: 0.0)
    }
    
    private func updatePointsLabelFrame() {
        
        let coordinateByX = starImageView.frame.origin.x - currentPointsLabel.frame.width - 5.0
        currentPointsLabel.frame.origin = CGPoint(x: coordinateByX, y: 0.0)
    }
}
