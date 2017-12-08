//
//  SSBaseTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/28/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseTableViewCell: UITableViewCell {
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Settings for Cell
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
}
