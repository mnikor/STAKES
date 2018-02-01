//
//  SSSelectCircleButton.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/22/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

enum SSCircleButtonType {
    case goal, action
}

class SSSelectCircleButton: SSBaseButton {
    
    
    // MARK: Public Properties
    var selectedGoal: Goal?
    var selectedAction: Action?
    var typeButton: SSCircleButtonType = .goal
    
    var isSelectedView = false {
        didSet {
            if isSelectedView {
                circleView.selectedView()
            } else {
                change(type: typeButton)
            }
        }
    }
    
    
    // MARK: Private Properties
    
    // Properties for Goal type
    private var circleView: SSTimeLinePointView!
    private var circleViewSize: CGFloat = 33.0
    private var sizeBorderView: SSBorderSize = .medium
    private var viewColorType: SSConstants.colorType = .red
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settingsUI()
    }
    
    
    // MARK: Overriden funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setConstraintsCircleView()
    }
    
    
    // MARK: Public funcs
    
    // Select Button Type
    func change(type: SSCircleButtonType) {
        
        switch type {
        case .goal:
            
            // Installed above
            break
        case .action:
            
            circleViewSize = 20.0
            sizeBorderView = .small
            viewColorType = .defaultBlack
        }
        
        circleView.frame.size = CGSize(width: circleViewSize, height: circleViewSize)
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.makeBorder(width: sizeBorderView, color: UIColor.colorFrom(colorType: viewColorType))
        circleView.backgroundColor = .white
        circleView.isUserInteractionEnabled = false
        self.typeButton = type
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let circleViewFrame = CGRect(origin: frame.origin, size: CGSize(width: circleViewSize, height: circleViewSize))
        circleView = SSTimeLinePointView(frame: circleViewFrame)
        self.addSubview(circleView)
        self.backgroundColor = .clear
    }
    
    // Set Constraints for Circle View
    private func setConstraintsCircleView() {
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: circleViewSize).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: circleViewSize).isActive = true
    }
}
