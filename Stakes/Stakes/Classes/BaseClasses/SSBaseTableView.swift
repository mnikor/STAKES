//
//  SSBaseTableView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/7/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseTableView: UITableView {
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let customSeparatorColor = UIColor.colorFrom(colorType: .defaultBlack).withAlphaComponent(0.15)
        separatorColor = customSeparatorColor
    }
}
