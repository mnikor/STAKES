//
//  SSPointsView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/23/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSPointsView: UIView {
    
    
    // MARK: Private Properties
    private let viewSize = CGSize(width: 70.0, height: 19.0)
    private var currentPointsLabel = UILabel()
    private var starImageView = UIImageView()
    
    
    // MARK: Public funcs
    func updatePointsView() {
        
        currentPointsLabel.text = SSPoint().getCurrentPoints()
        currentPointsLabel.font = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: 16.0)
        currentPointsLabel.sizeToFit()
        
        let coordinateByX = starImageView.frame.origin.x - currentPointsLabel.frame.width - 5.0
        currentPointsLabel.frame.origin = CGPoint(x: coordinateByX, y: 0.0)
    }
    
    
    // MARK: Initializers
    init() {
        super.init(frame: CGRect(origin: .zero, size: viewSize))
        
        initStarImageView()
        updatePointsView()
        
        starImageView.tintColor = .white
        currentPointsLabel.textColor = .white
        
        addSubview(currentPointsLabel)
        addSubview(starImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Private funcs
    private func initStarImageView() {
        
        let starImage = UIImage(named: "points_star")?.withRenderingMode(.alwaysTemplate)
        
        starImageView = UIImageView(image: starImage)
        starImageView.frame.origin = CGPoint(x: frame.width - starImageView.frame.width, y: 0.0)
    }
}
