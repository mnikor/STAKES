//
//  SSCircleViewCoordinates.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

typealias SSCircleCoordinate = [SSCircleType: CGPoint]

struct SSCircleViewCoordinates {
    
    
    // MARK: Private Properties
    private var coordinatesArray: [SSCircleCoordinate] {
        return [firstScreenCoordinates,
                secondScreenCoordinates,
                thirdScreenCoordinates,
                fourthScreenCoordinates]
    }
    
    private let firstScreenCoordinates: SSCircleCoordinate = [.purple: CGPoint(x: -240, y: -258),
                                                            .green: CGPoint(x: 248, y: -64),
                                                            .red: CGPoint(x: 222, y: 429),
                                                            .orange: CGPoint(x: -300, y: 300)]
    
    private let secondScreenCoordinates: SSCircleCoordinate = [.purple: CGPoint(x: -370, y: -102),
                                                             .green: CGPoint(x: 146, y: -199),
                                                             .red: CGPoint(x: 42, y: 600),
                                                             .orange: CGPoint(x: -380, y: 238)]
    
    private let thirdScreenCoordinates: SSCircleCoordinate = [.purple: CGPoint(x: -370, y: 135),
                                                            .green: CGPoint(x: 0, y: -264),
                                                            .red: CGPoint(x: 306, y: 300),
                                                            .orange: CGPoint(x: -323, y: 505)]
    
    private let fourthScreenCoordinates: SSCircleCoordinate = [.purple: CGPoint(x: -135, y: -363),
                                                             .green: CGPoint(x: 306, y: -64),
                                                             .red: CGPoint(x: 155, y: 450),
                                                             .orange: CGPoint(x: -374, y: 0)]
    
    
    // MARK: Public funcs
    func getCoordinatesFor(screen: Int) -> SSCircleCoordinate {
        return coordinatesArray[screen]
    }
    
    func getChangedCoordinatesFrom(currentScreen: Int, to destinationScreen: Int, by percent: CGFloat) -> SSCircleCoordinate {
        
        let currentCoordinates = getCoordinatesFor(screen: currentScreen)
        let destinationCoordinates = getCoordinatesFor(screen: destinationScreen)
        var changedCoordinate = destinationCoordinates
        
        for type in SSCircleType.arrayCircleTypes {
            if let currentCoordinate = currentCoordinates[type],
                let destinationCoordinate = destinationCoordinates[type] {
                
                let distanceByX = destinationCoordinate.x - currentCoordinate.x
                let distanceByY = destinationCoordinate.y - currentCoordinate.y
                
                let passedDistanceByX = distanceByX - (distanceByX * percent)
                let passedDistanceByY = distanceByY - (distanceByY * percent)
                
                changedCoordinate[type]?.x = currentCoordinate.x + passedDistanceByX
                changedCoordinate[type]?.y = currentCoordinate.y + passedDistanceByY
            }
        }
        return changedCoordinate
    }
}
