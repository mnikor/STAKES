//
//  Float+StakeString.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/28/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation

extension Float {
    
    func stakeString() -> String {
        
        let result = String(format: "%.2f", self)
        return "$" + result
    }
}
