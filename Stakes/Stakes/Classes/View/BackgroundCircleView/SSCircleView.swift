//
//  SSCircleView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


enum SSCircleType: Int {
    case purple = 0xA5B0FF
    case green = 0x7CEAC4
    case red = 0xEF8686
    case orange = 0xEABC7C

    static var arrayCircleTypes: [SSCircleType] {
        return [.purple, .green, .red, .orange]
    }
}


class SSCircleView: UIView {
    
    
    // MARK: Public Properties
    var destinationScreen = 1
    var currentScreen = 0
    
    
    // MARK: Private Properties
    private let circleSize = CGSize(width: 393, height: 393)
    private var circleViewsDictionary = [SSCircleType: UIView]()
    private var circleCoordinates = SSCircleViewCoordinates()
    
    
    // MARK: Public funcs
    func createCircleViewsFor(currentScreen: Int) {
        let coordinates = circleCoordinates.getCoordinatesFor(screen: currentScreen)
        
        for type in SSCircleType.arrayCircleTypes {
            
            let circleCoordinate = coordinates[type]
            let circleView = createCircleView(coordinate: circleCoordinate!, circleType: type)
            
            circleViewsDictionary[type] = circleView
            self.addSubview(circleView)
        }
    }
    
    func changeCircleViewsBy(percent: CGFloat) {
        
        let coordinates = circleCoordinates.getChangedCoordinatesFrom(currentScreen: currentScreen, to: destinationScreen, by: percent)
        
        for type in circleViewsDictionary.keys {
            guard let newOrigin = coordinates[type] else { return }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                
                self?.circleViewsDictionary[type]?.frame.origin = newOrigin
            }
        }
    }
    
    
    // MARK: Private funcs
    private func createCircleView(coordinate: CGPoint, circleType: SSCircleType) -> UIView {
        let circle = UIView(frame: CGRect(origin: coordinate, size: circleSize))
        
        circle.backgroundColor = UIColor.fromRGB(rgbValue: circleType.rawValue)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = circle.frame.width / 2
        circle.isUserInteractionEnabled = false
        return circle
    }
}
