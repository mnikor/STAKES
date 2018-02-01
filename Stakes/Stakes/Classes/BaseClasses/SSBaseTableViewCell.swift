//
//  SSBaseTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/28/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

@objc protocol SSSelectCircleButtonDelegate {
    
    // Optional
    @objc optional func tappedEditButton(_ goal: Goal?)
    
    // Required
    func selectCircleButton(_ sender: SSSelectCircleButton)
}


class SSBaseTableViewCell: UITableViewCell {
    
    
    // MARK: Delegate
    weak var delegate: SSSelectCircleButtonDelegate?
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Settings for Cell
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
}
